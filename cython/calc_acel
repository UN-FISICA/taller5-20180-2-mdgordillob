import argparse
import calc_mod
parser = argparse.ArgumentParser(description='Calcula la aceleracion en caida libre de imagenes de pelotas de billar')
parser = argparse.ArgumentParser()
parser.add_argument("-imname", help="nombre del archivo a procesar")
parser.add_argument("-hz", help="frecuencia del estroboscopio",
                    type=float)
parser.add_argument("-dx", help="tamano de cada pixel de la imagen en mm",
                    type=float)
args = parser.parse_args()
from timeit import Timer
t = Timer(lambda: calc_mod.calc(args.imname,args.hz,args.dx))
print(t.timeit(number=1))

