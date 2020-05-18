size(1000,800);
int x=0,y=0;
for(int i=0;i<1000;i++){
  for(int j=0;j<800;j++){
    int d=(((i-x)^(j-y))+1024)%256;
    stroke(d/2,d,d*2);
    point(i,j);
  }
}
