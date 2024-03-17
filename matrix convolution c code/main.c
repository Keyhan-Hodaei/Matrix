#include <stdio.h>
const int SIZE = 512;
int main() {
  int n;
  int m;
  float mat1[SIZE][SIZE];
  float mat2[SIZE][SIZE];
  float mat3[SIZE][SIZE];
  scanf("%d%d", &n, &m);
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++) {
      scanf("%f", &mat1[i][j]);
      mat3[i][j] = 0.0;
    }

  for (int i = 0; i < m; i++)
    for (int j = 0; j < m; j++)
      scanf("%f", &mat2[i][j]);

  for (int i = 0; i < n - m + 1; i++)
    for (int j = 0; j < n - m + 1; j++)
      for (int k = 0; k < m; k++)
        for (int l = 0; l < m; l++)
          mat3[i][j] += mat1[i + k][j + l] * mat2[k][l];

  for (int i = 0; i < n - m + 1; i++) {
    for (int j = 0; j < n - m + 1; j++)
      printf("%f ", mat3[i][j]);
    printf("\n");
  }
}
