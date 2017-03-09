/*
 * Loads a PRU executable binary, runs it, and waits for completion.
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <prussdrv.h>
#include <pruss_intc_mapping.h>

int main(int argc, char **argv) 
{
	unsigned int *prumem;
	unsigned int main_loop_iterations;
	unsigned int delay_loop_iterations;

	if (argc != 3) {
		printf("Usage: %s <main-loop-iterations> <delay-loop-iterations>\n", argv[0]);
		return 1;
	}

	main_loop_iterations = strtol(argv[1], NULL, 0);

	if (main_loop_iterations == 0 || errno != 0) {
		printf("Invalid value for main-loop-iterations: %s\n", argv[1]);
		return 1;
	}

	delay_loop_iterations = strtol(argv[2], NULL, 0);

	if (delay_loop_iterations == 0 || errno != 0) {
		printf("Invalid value for delay-loop-iterations: %s\n", argv[2]);
		return 1;
	}

	prussdrv_init();

	if (prussdrv_open(PRU_EVTOUT_0) == -1) {
		printf("prussdrv_open() failed\n");
		return 1;
	}

	if (prussdrv_map_prumem(PRUSS0_PRU0_DATARAM, (void **)&prumem) == -1) {
		printf("prudrv_map_prumem() failed\n");
		return 1;
	}

	prumem[0] = main_loop_iterations;
	prumem[1] = delay_loop_iterations;
 
	tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;

	prussdrv_pruintc_init(&pruss_intc_initdata);

	printf("Executing program and waiting for termination\n");

	if (prussdrv_exec_program(PRU0, "loop.bin") < 0) {
		fprintf(stderr, "Error loading : loop.bin\n");
		exit(1);
	}

	// Wait for the PRU to let us know it's done
	prussdrv_pru_wait_event(PRU_EVTOUT_0);
	printf("Done\n");

	prussdrv_pru_disable(PRU0);
	prussdrv_exit();

	return 0;
}
