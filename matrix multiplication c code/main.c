#include <stdio.h>
const int SIZE = 512;
int main() {
  int n;
  float mat1[SIZE][SIZE];
  float mat2[SIZE][SIZE];
  float mat3[SIZE][SIZE];

  scanf("%d", &n);
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      scanf("%f", &mat1[i][j]);

  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      scanf("%f", &mat2[i][j]);

  for (int i = 0; i < n; i++)
    for (int k = 0; k < n; k++)
      for (int j = 0; j < n; j++)
        mat3[i][j] += mat1[i][k] * mat2[k][j];

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++)
      printf("%f ", mat3[i][j]);
    printf("\n");
  }
}
