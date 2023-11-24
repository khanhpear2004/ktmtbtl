#include<iostream>
#include<vector>

using namespace std;

void swap(int &a, int &b){
    int tmp = a;
    a = b;
    b = tmp;
}

void merge(int a[], int l, int m, int r){
    vector<int> x(a + l, a + m + 1);
    vector<int> y(a + m + 1, a + r + 1);
    int i = 0; int j = 0;
    while(i < x.size() && j < y.size()){
        if(x[i] <= y[j]){
            a[l] = x[i]; l++; i++;
        }
        else{
            a[l] = y[j]; l++; j++;
        }
    }
    while(i < x.size()){
        a[l] = x[i]; l++; i++;
    }
    while(j < y.size()){
        a[l] = y[j]; l++; j++;
    }
}

//Lomuto
int partitionL(int a[], int l, int r){
    int pivot = a[r];
    int i = l - 1;
    for(int j = l; j < r; j++){
        if(a[j] <= pivot){
            ++i;
            swap(a[i], a[j]);
        }
    }
    ++i;
    swap(a[i], a[r]);
    return i;
}

//Houre
int partitionH(int a[], int l, int r){
    int pivot = a[l];
    int i = l - 1, j = r + 1;
    while(1){
        do{
            i++;
        }while(a[i] < pivot);
        do{
            j--;
        }while(a[j] > pivot);
        if(i < j) swap(a[i], a[j]);
        else return j;
    }
}

void quickSortL(int a[], int l, int r){
    if(l >= r) return;
    int p = partitionL(a, l, r);
    quickSortL(a, l, p - 1);
    quickSortL(a, p + 1, r);
}

void quickSortH(int a[], int l, int r){
    if(l >= r) return;
    int p = partitionH(a, l, r);
    quickSortH(a, l, p);
    quickSortH(a, p + 1, r);
}

void mergeSort(int a[], int l, int r){
    if(l >= r) return;
    int m = (l + r)/2; //m = 0 + 3 = 0
    mergeSort(a, l, m); //a, 0, 1
    mergeSort(a, m + 1, r);//a, 
    merge(a, l, m, r);
}

int main(){
    int a[8] = {6,4,2,7,8,1,3,5};

    
    mergeSort(a, 0, 7);
    for(int i = 0; i < 8; i++){
        cout<<a[i]<<" ";
    }
}