practicas-arch-comp
===================

Prácticas de la clase de Arquitectura de Computadoras, Primavera 2014.

Práctica 1
----------

Abrir asm en MARS y ejecutarlo ahí.

Práctica 2
----------

Para editar: añadir la carpeta `Practica2/MIPSQuartusII` y ahí poner el proyecto de Quartus.

Para simular: en ModelSIM:

1. Cambiar directorio a `Practica2/MIPSModelsim`
2. Compile All, Simulate y guardar `wave.do`
3. Crear archivo `sim.do` con lo siguiente (modificando el path al propio):
```
noview wave
vsim work.MIPS_TB
do C:/path/to/practicas-arch-comp/Practica2/MIPSModelsim/wave.do
run 200
```
4. Añadir archivo `text.dat` que contenga el programa en "Hexadecimal text", tal cual como MARS lo generó.
5. Ejecutar: `do sim.do`
