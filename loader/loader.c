/*
 * Loads a PRU executable binary, runs it, and waits for completion.
 */

#include <stdio.h>
#include <stdlib.h>
#include <prussdrv.h>
#include <pruss_intc_mapping.h>

int main(int argc, char **argv) 
{
	if (argc != 2) {
		printf("Usage: %s <text.bin>\n", argv[0]);
		return 1;
	}

	prussdrv_init();

	if (prussdrv_open(PRU_EVTOUT_0) == -1) {
		printf("prussdrv_open() failed\n");
		return 1;
	}

	tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;

	prussdrv_pruintc_init(&pruss_intc_initdata);

	printf("Executing program and waiting for termination\n");

	if (prussdrv_exec_program(PRU0, argv[1]) < 0) {
		fprintf(stderr, "Error loading %s\n", argv[1]);
		exit(-1);
	}

	// Wait for the PRU to let us know it's done
	prussdrv_pru_wait_event(PRU_EVTOUT_0);
	printf("Done\n");

	prussdrv_pru_disable(PRU0);
	prussdrv_exit();

	return 0;
}
