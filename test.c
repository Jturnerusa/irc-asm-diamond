#include <assert.h>
#include <stdio.h>

int ircd_strlen(char *p);
int ircd_ctoi(char c, int *err);
int ircd_stoi(char *p, int *err);

int main(int argc, char **argv) {
  assert(ircd_strlen("hello world") == 11);

  int i = 0;
  int err = 0;

  i = ircd_ctoi('1', &err);
  assert(i == 1 && err == 0);

  i = ircd_ctoi('a', &err);
  assert(err == 1);

  i = 0;
  err = 0;
  i = ircd_stoi("100", &err);
  printf("%d\n", i);
  /* assert(i == 100 && err == 0); */

  /* i = ircd_stoi("102", &err); */
  /* assert(i == 102 && err == 0); */

  /* i = ircd_stoi("abc", &err); */
  /* assert(err == 1); */

  return 0;
}
