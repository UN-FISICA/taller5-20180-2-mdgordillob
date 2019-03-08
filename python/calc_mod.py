import scipy.ndimage as  nd
import scipy.misc as misc
import numpy as np
import scipy.ndimage as ndimage
from numpy.linalg import inv,lstsq
from pylab import *
from scipy.ndimage.measurements import center_of_mass,minimum_position,extrema,labeled_comprehension
from pylab import imshow,show,figure,colorbar,ones,imread,where
def calc(l,f,pix):
	#Comando para abrir la imagen como una matriz
	a=misc.imread(l,mode="L")
	#Le calculo el color promedio a la imagen, teniendo en cuenta que la mayoria de la imagen de las bolas es el fondo	
	promediocolor=a.mean()
	#print(promediocolor)
	#Como los fondos son blancos o negros elegi arbitrariamente los valores de color que funcionan mejor 
	#claro
	if(promediocolor>=200):	
		b=ndimage.maximum_filter(a,2)	
		b=where(a>200,0,255)
	#negro
	if(promediocolor<=30):
		b=where(a<53,0,255)
		b=ndimage.maximum_filter(b,(4,1))
	lblim1,n1=nd.label(b)
	surface_areas = np.bincount(lblim1.flat)[1:]
	treshold=np.average(surface_areas)
	#centers = center_of_mass(lblim, labels=lblim, index=range(1, n+1
	#min_pos = minimum_position(lblim, labels=lblim, index=range(1, n+1))
	#labeled_comprehension(lbim, labels=lblim, index=range(1, n+1),fn,float,0,True)
	#print(lblim)
	#print(min_pos)
	#imshow(lblim)
	#show()
	size=np.bincount(lblim1.ravel())
	treshold1=82
	keep_labels1=size>=treshold1
	keep_labels1[0]=0
	filtered_labels1=keep_labels1[lblim1]
	lblim1,n1=nd.label(filtered_labels1)
	lblim=lblim1
	keep_labels=size<=treshold	
	keep_labels[0]=0
	filtered_labels = keep_labels[lblim]
	lblim,n=nd.label(filtered_labels)
	#imshow(lblim)
	#show()
	#print(centers
	#print(size)
	#show()
	z=np.zeros(n)
	x=np.zeros(n)
	centers = center_of_mass(lblim, labels=lblim, index=range(1, n+1))
	for i in range(0,n):
		y=centers[i]
		z[i]=(y[0])*pix
		#print(z[i])
	for j in range(4,n+4):
		x[j-4]=j*f
	#print(z,x)
	f=[]
	f.append(lambda x:np.ones_like(x))
	f.append(lambda x:x)
	f.append(lambda x:x**2)
	t=[]
	Xt=[]
	for fu in f:
		Xt.append(fu(x))
	Xt=np.array(Xt)
	X=Xt.transpose()
	a = lstsq(X,z,rcond=None)[0]
	y1=0
	for k,ac in enumerate(a):
		y1=y1+ac*(x**k)
	g=2*a[2]
	print(g)	
	return g











	
	
