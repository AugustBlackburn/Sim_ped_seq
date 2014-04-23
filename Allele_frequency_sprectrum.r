###R-code to simulate allele frequencies under the infinite-alleles model with neutrality
####Effective population size####
Ne<-20000
####Mutation rate####
u<-10^-8
####Calculate theta####
theta<-4*Ne*u
n1<-seq(0.001,0.999,by=0.001)
myfunction<- function(x){
	hi<-(x^(theta-1))*((1-x)^(theta-1))
	return(hi)
}
distro<-myfunction(n1)
sum<-0
for(i in 1:999){sum<-sum+distro[i]}
distro_x<-distro/sum
pdf(file="Frequency_distribution.pdf")
plot(n1,distro_x,xlab="Allele frequency",ylab="Density")
dev.off()
distro_rounded<-round(distro,digits=0)
sim<-NULL
for(i in 1:999){sim<-append(sim,rep((0.001*i),distro_rounded[i]))}
write(sim,file="/Users/augustb/Desktop/frequency_distribution.csv",sep=',')
