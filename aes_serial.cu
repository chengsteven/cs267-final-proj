#include <stdlib.h>
#include <fstream>
#include <thrust/sort.h>
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <cuda.h>

#include "aes_common.h"


int main( int argc, char **argv )
{
    if ( find_option( argc, argv, "-h" ) >= 0 )
    {
        printf( "Options:\n" );
        printf( "-h to see this help\n" );
        printf( "-n number of bits for the key (128, 192, 256)\n" );
        printf( "-i input file to be encrypted\n" );
        printf( "-o <filename> to specify the output file name\n" );
        return 0;
    }

    int n = read_int( argc, argv, "-n", 128 );
    int num_rounds;
    if (n == 128) num_rounds = 10;
    else if (n == 192) num_rounds = 12;
    else if (n == 256) num_rounds = 14;
    else {
        printf("Key size needs to be either 128, 192, or 256 bits.");
        return 1;
    }


    char *savename = read_string( argc, argv, "-o", NULL );
    char *inputname = read_string( argc, argv, "-i", NULL );
    FILE *fsave = savename ? fopen( savename, "w" ) : NULL;
    FILE *finput = inputname ? fopen( inputname, "r" ) : NULL;
    if (finput == NULL) 
    {
        printf("Needs an input file.\n");
        return 1;
    }

    fseek(finput, 0L, SEEK_END);
    long filesize = ftell(finput);
    rewind(finput);
    fseek(finput, 0L, SEEK_SET);

    char* buf = (char*) malloc(sizeof(char) * filesize + 1);

    size_t read = fread(buf, sizeof(char), filesize, finput);
    if (read != filesize) 
    {
        printf("Read number of bytes was different than actual size.\n");
    }

    printf("input: \n%s\n", buf);

    double simulation_time = read_timer();
    // do the actual encryption


    simulation_time = read_timer() - simulation_time;
    // do decryption to verify correctness

    printf( "n = %d, simulation_time = %g seconds\n", n, simulation_time);

    if( fsave )
        fclose( fsave );

    return 0;
}

