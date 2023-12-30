#include <stdio.h>
#include <stdlib.h>

int maze[100][100];
int endx, endy; // s2, s3
int dx[4] = {1, 0, -1, 0};
int dy[4] = {0, -1, 0, 1};
int n, m; // s0, s1
int cnt; // s5

void dfs(int fx, int fy);

int main() {
    scanf("%d %d", &n, &m);
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            scanf("%d", &maze[i][j]);
        }
    }
    int beginx, beginy;
    scanf("%d%d%d%d", &beginx, &beginy, &endx, &endy);
    cnt = 0;
    maze[beginx][beginy] = 1;
    dfs(beginx, beginy);
    printf("%d", cnt);
    return 0;
}

void dfs(int fx, int fy) {
    if (fx == endx && fy == endy) {
        cnt = cnt + 1;
        return ;
    }
    for (int i = 0; i < 4; i++) {
        int xx = fx + dx[i];
        int yy = fy + dy[i];
        if (xx > 0 && xx <= n && yy > 0 && yy <= m && maze[xx][yy] != 1) {
            maze[xx][yy] = 1;
            dfs(xx, yy);
            maze[xx][yy] = 0;
        }
    }
}

/**
 * 0 0 1 0 0 
 * 1 0 0 0 1
 * 1 0 1 0 1
 * 1 0 0 0 0 
 */