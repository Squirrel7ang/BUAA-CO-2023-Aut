#include<iostream>
using namespace std;

int a[10000], i, j, l = 0, s, n;  

int main() {    
     cin >> n;    
     a[0] = 1;    
     for(int i = 1; i <= n; i++) {
          s=0;        
          for(int j=0;j<=l;j++) {            
               s=s+a[j]*i;          
               a[j]=s%10;           
               s/=10;       
          }       
          while(s) {            
               l++;          
               a[l]=s%10;          
               s/=10;       
          }   
     }    
     for(int i=l;i>=0;i--) {       
         cout << a[i];  
     }   
     return 0;
}