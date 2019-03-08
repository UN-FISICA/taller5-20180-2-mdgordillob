cimport cython
cimport numpy as cnp
from cython cimport boundscheck, wraparound
from cython.view cimport array as cvarray
import scipy.ndimage as  nd
import scipy.misc as misc
import numpy as np
from numpy.linalg import inv,lstsq
from scipy.ndimage.measurements import center_of_mass,minimum_position,extrema,labeled_comprehension
from pylab import imshow,show,figure,colorbar,ones,imread,where
import cProfile, pstats, io
def profile(fnc):
	def inner(*args, **kwargs):
		pr = cProfile.Profile()
		pr.enable()
		retval = fnc(*args, **kwargs)
		pr.disable()
		s = io.StringIO()
		sortby = 'cumulative'
		ps = pstats.Stats(pr, stream=s).sort_stats(sortby)
		ps.print_stats()
		print(s.getvalue())
		return retval

	return inner
#Fijo el tipo de variables para la matriz de la imagen y demas variables del programa
#def binar0(
cdef binar0(int[:,::1]mv,int cmin,int r):
	cdef int N,M,i,j
	N=mv.shape[0]
	M=mv.shape[1]
	for i in range(N):
		for j in range(M):
			if(mv[i,j]<cmin):
				mv[i,j]=0
			else:
				mv[i,j]=1
	return mv
cdef binar1(int[:,::1]mv,int cmax,int r):
	cdef int N,M,i,j
	N=mv.shape[0]
	M=mv.shape[1]
	for i in range(N):
			for j in range(M):
				if(mv[i,j]>cmax):
					mv[i,j]=r
				else:
					mv[i,j]=1
	return mv
cdef promedio(int[:,::1]mv):
	cdef int N,M,i,j,U
	cdef double p,r
	N=mv.shape[0]
	M=mv.shape[1]
	U=N*M
	p=0
	for i in range(N):
		for j in range(M):
			p=p+mv[i,j]
	r=p/U
	return r
cdef label(int[:,::1]mv):
	cdef int k=1,i,j,N,M,l,left,left1,above,above1
	cdef int [:,::1] lab
	l=0
	N=mv.shape[0]
	M=mv.shape[1]
	buf=np.zeros((N,M),dtype=np.int32)
	lab=buf
	for i in range(0,N):
		for j in range(0,M):
			if(mv[i,j]!=0):
				left=mv[i-1,j]
				above=mv[i,j-1]
				left1=lab[i-1,j]
				above1=lab[i,j-1]
				if(left==0 and above==0 and mv[i-1,j-1]==0 and mv[i-1,j+7]==0):
					l=l+1
					lab[i,j]=l
				elif(left!=0 and above==0):
					lab[i,j]=lab[i-1,j]
				elif(left==0 and above!=0):
					lab[i,j]=lab[i,j-1]
				elif(left==above and left!=0):
					lab[i,j]=l
				else:
					lab[i,j-1]=lab[i-1,j]
				#if(lab[i,j]!=0):
					#print(lab[i,j])
					
						
	return lab,l

cdef area(int[:,::1]mv,int o,double pix):
	cdef int [:] x
	cdef double [:]m
	cdef double t	
	cdef int i=0,j=0,k,l
	N=mv.shape[0]
	M=mv.shape[1]
	x=np.zeros(o-2,dtype=np.int32)
	m=np.zeros(o-2,dtype=np.float64)
	for k in range (2,o):
		t=0
		l=0
		for i in range(0,N):
			for j in range(0,M):
				if(mv[i,j]==k):
					l=l+1
					t=t+i
		x[k-2]=l
		m[k-2]=(t/l)*pix
	return m
cdef minimosc(double [:]x,double [:]t):
	
	cdef double[:,::1] A
	cdef int N,M,i,j,g
	N=t.shape[0]
	A=np.zeros((N,3),dtype=np.float64)
	for i in range(0,N):
		A[i,0]=1
		A[i,1]=t[i]
		A[i,2]=t[i]*t[i]
	K=np.asarray(A)
	h=np.asarray(x)
	u=np.dot(np.dot(np.linalg.inv(np.dot(K.transpose(),K)),K.transpose()),h)
	g=2*u[2]
	print g	
	return g
	
	
	
				
				
	
	
	 
	
						
#cdef find(int x):
	#cdef int y=x	
#@profile
def calc(l,f,double pix):
	#Comando para abrir la imagen como una matriz
	cdef double promediocolor
	cdef int[:,::1] img_view
	cdef int[:,::1] b,c
	cdef double[:]m,v
	y=misc.imread(l,mode="L")
	x=np.copy(y)
	a=x.astype(np.int32)
	img_view=a
	#Le calculo el color promedio a la imagen, teniendo en cuenta que la mayoria de la imagen de las bolas es el fondo	
	promediocolor=promedio(img_view)	
	#print(promediocolor)
	#Como los fondos son blancos o negros elegi arbitrariamente los valores de color que funcionan mejor 
	#claro
	if(promediocolor>=200):	
		b=binar1(img_view,200,0)
	#negro
	cdef unsigned int n1
	cdef unsigned int n
	cdef unsigned int i
	cdef unsigned int j
	cdef unsigned int lul
	cdef double g
	if(promediocolor<=30):
		b=binar0(img_view,53,0)
	c,lul=label(b)
	m=area(c,lul,pix)
	v=np.zeros(lul-2,dtype=np.float64)
	for j in range(2,lul):
		v[j-2]=j*f
	g=minimosc(m,v)
	
	












	
	
