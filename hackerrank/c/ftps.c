#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define BUFF_SIZE 1000
#define FILE_NAME_SIZE 256

int writeFile(FILE *inputFile, int sd);
int errorHandler(int rc, char *section);

int main(int argc, char *argv[]) {
  struct sockaddr_in addr;
  char file_name_buffer[FILE_NAME_SIZE], buffer[BUFF_SIZE], ip[29];
  FILE *fp;
  int file_name_size, c_file_name_size, port, rc, sd, bytesAck;

  // check for correct number of arguments
  if (argc < 3) {
    printf("Usage is: client <ip> <port>\n");
    exit(1);
  }
  
  // create socket
  sd = socket(AF_INET, SOCK_STREAM, 0);
  port = strtol(argv[2], NULL, 10);

  strcpy(ip, argv[1]);

  addr.sin_family = AF_INET;
  addr.sin_port = htons(port);
  addr.sin_addr.s_addr = inet_addr(ip);
  
  // connect to server
  if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
    close(sd);
    perror("Error connecting to server");
    exit(1);
  }
  
  // main loop
  while (1) {
    // Prompt user for file path
    printf("\nEnter file path: ");
    memset(file_name_buffer, 0, FILE_NAME_SIZE);
    scanf("%s", file_name_buffer);
    // Prompt for valid input
    while (access(file_name_buffer, F_OK) && strcmp(file_name_buffer, "DONE")) {
      printf("File does not exist. Enter file name: \n");
      memset(file_name_buffer, 0, FILE_NAME_SIZE);
      scanf("%s", file_name_buffer);
    }

    // check for exit condition
    if (!strcmp(file_name_buffer, "DONE")) {
      printf("Exiting!\n");
      close(sd);
      exit(1);
    }

    // send file name size
    file_name_size = strlen(file_name_buffer);
    c_file_name_size = htonl(file_name_size);
    rc = write(sd, &c_file_name_size, sizeof(file_name_size));
    errorHandler(rc, "file name size send");
    printf("Sent file name size %d in %d bytes. \n", file_name_size, rc);

    // send file name
    rc = write(sd, file_name_buffer, strlen(file_name_buffer));
    errorHandler(rc, "file name send");
    printf("Sent filename \"%s\". \n", file_name_buffer);

    // open file
    fp = fopen(file_name_buffer, "r");
    printf("Opened file %s. \n", file_name_buffer);

    // send file
    writeFile(fp, sd);
    fclose(fp);

    rc = read(sd, &bytesAck, sizeof(bytesAck));
    printf("Server sent %d bytes. \n", rc);
    printf("Server received %d bytes. \n", ntohl(bytesAck));
  }

  // close socket
  close(sd);
  return 0;
}
// read and then write data to socket
int writeFile(FILE *inputFile, int sd) {
  char buffer[BUFF_SIZE + 1];
  int rc = 0, fs, bytesRead, totalBytesRead = 0, totalBytesWritten = 0, c_fs;

  // get file size
  fseek(inputFile, 0L, SEEK_END);
  fs = ftell(inputFile);
  fseek(inputFile, 0L, SEEK_SET);
  c_fs = htonl(fs);
  printf("File size is htonl(%d)=%d bytes. \n", fs, c_fs);

  // send file size
  rc = write(sd, &c_fs, sizeof(c_fs));
  errorHandler(rc, "file size send");
  printf("Sent file size in %i bytes. \n", rc);

  // send file

  memset(buffer, 0, BUFF_SIZE);
  printf("Sending file... (live print disabled because slow and expensive with 1 byte per :) )\n");
  while ((bytesRead = fread(buffer, 1, 1, inputFile)) > 0) {
    totalBytesRead += bytesRead;
    rc = write(sd, buffer, 1);
    totalBytesWritten += rc;
    errorHandler(rc, "file write loop");
    /*if (rc != 0) {
      printf("\033[1A");
      printf("Sent %i bytes, %i/%i. cursor at pos: %i. \n", rc,
             totalBytesWritten, fs, totalBytesRead);
    }*/
    memset(buffer, 0, BUFF_SIZE);
  }
  return 0;
}

int errorHandler(int rc, char *section) {
  if (rc < 0) {
    perror(section);
    exit(1);
  } else if (rc == 0) {
    perror("rc is 0");
  }
  return 0;
}
