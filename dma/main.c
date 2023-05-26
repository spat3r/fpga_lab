//*****************************************************************************
//* DMA teszt alkalmazás.                                                     *
//*****************************************************************************
#include <xparameters.h>
#include <xaxidma_hw.h>
#include <mb_interface.h>
#include <stdio.h>


//*****************************************************************************
//* Makrók a memória eléréshez.                                               *
//*****************************************************************************
#define MEM8(addr)    (*(volatile unsigned char *)(addr))
#define MEM16(addr)   (*(volatile unsigned short *)(addr))
#define MEM32(addr)   (*(volatile unsigned long *)(addr))


//*****************************************************************************
//* A DMA adatátvitelhez használt bufferek. Ezeket 128 bájtos határra         *
//* igazítjuk és a külsõ DDR3 memóriában helyzzük el.                         *
//*****************************************************************************
unsigned char dma_tx_buf[1024*1024] __attribute__((aligned(128), section(".extmem")));
unsigned char dma_rx_buf[1024*1024] __attribute__((aligned(128), section(".extmem")));


//*****************************************************************************
//* Az AXI DMA perifériát kezelõ fügvények.                                   *
//*****************************************************************************
void dma_init(unsigned long baseaddr)
{
	//Az MM2S csatorna engedélyezése: a vezérlõ reg. RS bitjének 1-be állítása.
	//Megszakításokat nem használunk.
	MEM32(baseaddr + XAXIDMA_TX_OFFSET + XAXIDMA_CR_OFFSET) = XAXIDMA_CR_RUNSTOP_MASK;

	//AZ S2MM csatorna engedélyezése: a vezérlõ reg. RS bitjének 1-be állítása.
	//Megszakításokat nem használunk.
	MEM32(baseaddr + XAXIDMA_RX_OFFSET + XAXIDMA_CR_OFFSET) = XAXIDMA_CR_RUNSTOP_MASK;
}

void dma_mm2s_start(unsigned long baseaddr, void *src, unsigned long length)
{
	//A forráscím beállítása. A felsõ 32 bit mindig 0.
	MEM32(baseaddr + XAXIDMA_TX_OFFSET + XAXIDMA_SRCADDR_OFFSET) = (unsigned long) src;
	MEM32(baseaddr + XAXIDMA_TX_OFFSET + XAXIDMA_SRCADDR_MSB_OFFSET) = 0;
	//Az adatméret beállítása, ennek hatására indul az MM2S DMA átvitel.
	MEM32(baseaddr + XAXIDMA_TX_OFFSET + XAXIDMA_BUFFLEN_OFFSET) = length;

}

void dma_s2mm_start(unsigned long baseaddr, void *dst, unsigned long length)
{
	//A célcím beállítása. A felsõ 32 bit mindig 0.
	MEM32(baseaddr + XAXIDMA_RX_OFFSET + XAXIDMA_SRCADDR_OFFSET) = (unsigned long) dst;
	MEM32(baseaddr + XAXIDMA_RX_OFFSET + XAXIDMA_SRCADDR_MSB_OFFSET) = 0;
	//Az adatméret beállítása, ennek hatására indul az S2MM DMA átvitel.
	MEM32(baseaddr + XAXIDMA_RX_OFFSET + XAXIDMA_BUFFLEN_OFFSET) = length;
}

void dma_mm2s_wait(unsigned long baseaddr)
{
	unsigned long status;

	//Várakozás, amíg az MM2S DMA átvitel be nem fejezõdik.
	for (;;)
	{
		//A státusz regiszter beolvasása.
		status = MEM32(baseaddr + XAXIDMA_TX_OFFSET + XAXIDMA_SR_OFFSET);
		//Kilépünk a ciklusból, ha az IDLE bit 1.
		if (status & XAXIDMA_IDLE_MASK)
			break;
	}
}

void dma_s2mm_wait(unsigned long baseaddr)
{
	unsigned long status;

	//Várakozás, amíg az S2MM DMA átvitel be nem fejezõdik.
	for (;;)
	{
		//A státusz regiszter beolvasása.
		status = MEM32(baseaddr + XAXIDMA_RX_OFFSET + XAXIDMA_SR_OFFSET);
		//Kilépünk a ciklusból, ha az IDLE bit 1.
		if (status & XAXIDMA_IDLE_MASK)
			break;
	}
}


//*****************************************************************************
//* Két buffer tartalmának összehasonlítása.                                  *
//*****************************************************************************
void mem_cmp(void *buf1, void *buf2, unsigned long length)
{
	unsigned char *ptr1 = (unsigned char *)buf1;
	unsigned char *ptr2 = (unsigned char *)buf2;
	unsigned long i;

	for (i = 0; i < length; i++)
	{
		if (ptr1[i] != ptr2[i])
		{
			xil_printf(
				"mem_cmp(): Compare error! buf1[%d]=0x%02x, buf2[%d]=0x%02x\r\n",
				i,
				ptr1[i],
				i,
				ptr2[i]
			);
			return;
		}
	}

	xil_printf("mem_cmp(): Content of the buffers is the same.\r\n");
}


//*****************************************************************************
//* Fõprogram.                                                                *
//*****************************************************************************
#define ENABLE_MB_DCACHE     1
#define DMA_TRANSFER_SIZE    1024

int main()
{
	unsigned long i;

	//Az adat cahce engedélyezése a MicroBlaze processzoron.
#if (ENABLE_MB_DCACHE != 0)
	microblaze_enable_dcache();
#endif

	//Az AXI DMA vezérlõ inicializálása.
	dma_init(XPAR_AXIDMA_0_BASEADDR);

	//A tömbök inicializálása.
	for(i = 0; i < 1024*1024; i++)
	{
		dma_tx_buf[i] = (unsigned char)(i & 0xff);
		dma_rx_buf[i] = 0x00;
	}

	//Tartalom összehasonlítás a DMA átvitel elõtt.
	mem_cmp(dma_tx_buf, dma_rx_buf, DMA_TRANSFER_SIZE);

	//A DMA adatátvitel elindítása. Ha az adat cache engedélyezve
	//van, akkor azt az MM2S írány indítása elõtt ki kell üríteni.
#if (ENABLE_MB_DCACHE != 0)
	microblaze_flush_dcache();
#endif

	dma_s2mm_start(XPAR_AXI_DMA_0_BASEADDR, dma_rx_buf, DMA_TRANSFER_SIZE);
	dma_mm2s_start(XPAR_AXI_DMA_0_BASEADDR, dma_tx_buf, DMA_TRANSFER_SIZE);

	//Várakozás a DMA átvitel befejezõdésére.

	dma_s2mm_wait(XPAR_AXI_DMA_0_BASEADDR);
	dma_mm2s_wait(XPAR_AXI_DMA_0_BASEADDR);

	//Ha az adat cache engedélyezve van, akkor azt az S2MM irányú
	//átvitel befejezõdése után és az adatbuffer hozzáférés elõtt
	//érvényteleníteni kell.
#if (ENABLE_MB_DCACHE != 0)
	microblaze_invalidate_dcache();
#endif

	//Tartalom összehasonlítás a DMA átvitel után.
	mem_cmp(dma_tx_buf, dma_rx_buf, DMA_TRANSFER_SIZE);

	for (;;);

	return 0;
}


