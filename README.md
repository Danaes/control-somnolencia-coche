## SISTEMA PARA LA DETECCIÓN AUTOMÁTICA DE DISTRACCIONES AL VOLANTE
### DESCRIPCIÓN DEL PROBLEMA
De acuerdo a diferentes estudios, una de las mayores causas de accidentes en carretera son las distracciones
al volante, bien por el uso de dispositivos electrónicos, la somnolencia u otras acciones que llevan al conductor
a desatender la conducción.
### OBJETIVO DEL SISTEMA
El objetivo general del sistema es detectar la falta de atención del conductor a partir de diferentes sensores
instalados en el vehículo. El sistema analizará la información obtenida de los sensores para detectar posibles
síntomas de distracciones. A partir de estos síntomas se definen unas situaciones de riesgo, ante las cuales el
sistema realizará diferentes actuaciones para hacer reaccionar al conductor.
### SENSORES:

- _Giróscopo_: Detector de giros en dos ejes (X,Y) para controlar la posición de la cabeza. La inclinación vendrá
medida en grados, entre -90º y + 90º. El eje X controla la inclinación de la cabeza hacia delante o hacia
atrás. El eje Y controla la inclinación de la cabeza hacia los lados (derecha o izquierda). En ambos casos,
cuando la cabeza esté completamente erguida el valor será muy próximo a 0º en ambos ejes.

- _Giro del volante_: Sensor que indica el grado de giro del volante en el rango de -180º a +180º. Si el volante
no está girado tendrá un valor de 0º. Valores negativosrepresentarán giros a la izquierda y valores positivos
giros a la derecha. Servirá para detectar posibles conducciones erráticas o volantazos. Esto se basa en la
idea de que cuando un conductor tiene falta de atención (por ejemplo, por atender el móvil o por sufrir
pequeñas somnolencias) tiende a hacer pequeñas correcciones bruscas en la dirección. En una situación
normal el giro del volante es más uniforme.

- _Velocímetro_: Indica la velocidad actual del vehículo. El convertidor A/D proporciona valores
comprendidos entre 0 y 1023, que representan el rango de velocidad de 0 a 200 Km/h.

- _Sensor de distancia_: Sensor de ultrasonidos ubicado en la parte frontal del vehículo para medir la
distancia con el vehículo precedente. Será capaz de medir la distancia en el rango de 5 a 150 metros. Servirá
para detectar que el conductor no está guardando la distancia de seguridad, por despiste o por falta de
prudencia.
### ACTUADORES:
- _Luces de aviso_: Habrá 2 luces, una luz amarilla y otra roja para indicar situaciones de mayor riesgo.

- _Display_: Se utilizará para visualizar datos que estará a la vista del piloto y el copiloto.

- _Alarma sonora_: para emitir pitidos con 5 niveles de intensidad.

- _Activación de freno automático_: El sistema activado el freno ante el peligro inminente de colisión. 

### DETECCIÓN DE SÍNTOMAS
El sistema leerá y analizará los datos recogidos de los sensores para detectar los siguientes indicios que pueden
llevar a una situación de riesgo.
- _Cabeza Inclinada_: Se leerá el Giróscopo cada 400 ms. Si la inclinación en el eje X es mayor de 30 grados en
al menos dos lecturas consecutivas se interpretará que el conductor tiene la Cabeza Inclinada hacia delante
(+30º) o hacia atrás (-30º) y puede estar dando síntomas de somnolencia o distracción. En caso de que se
produzcan las dos inclinaciones consecutivas en el eje Y, hacia la izquierda (-30º) o hacia la derecha (+30º),
si el conductor está girando el volante en el mismo sentido que la inclinación de la cabeza, no se
interpretará como somnolencia. En este caso, se supone que cuando un conductor está realizando una
curva acompaña instintivamente la trayectoria del vehículo con un movimiento de la cabeza. Sin embargo,
si el conductor inclina la cabeza lateralmente más de 30º y no está girando el volante se interpreta como
posible síntoma de somnolencia. La condición de “CABEZA INCLINADA” deja de ser cierta cuando se corrija
la posición de la cabeza.

- _Distancia de Seguridad_: Cada 300 ms el sistema medirá la distancia que le separa del vehículo que le
precede. Si la distancia es menor que la distancia de seguridad recomendada, siendo ésta igual a (Velocidad
/ 10)2
se considera el síntoma de DISTANCIA INSEGURA. Si la distancia es menor que la mitad de la distancia
de seguridad recomendada se interpretará que hay “DISTANCIA IMPRUDENTE” por no guardar la distancia
de seguridad. Si la distancia es menor que un tercio de la distancia de seguridad recomendada se
interpretará que hay “PELIGRO COLISION”. El síntoma desaparece cuando deja de cumplirse la situación
descrita.
### VISUALIZACIÓN DE DATOS
El sistema actualizará en el Display la siguiente información una vez por segundo:
- Distancia actual con el vehículo precedente

- Velocidad Actual

- Síntomas detectados en el conductor, según lo especificado en el epígrafe anterior.

No se especifica un formato concreto
### DETECCIÓN DE RIESGOS Y ACTUACIONES
Cada 150 ms. se analizarán los síntomas para detectar posibles riesgos, ante los cuales el sistema tendrá que
reaccionar llevando a cabo algunas actuaciones.

Si se da el síntoma de CABEZA INCLINADA el sistema emitirá un pitido de intensidad 1. Si además, la velocidad
del vehículo es mayor de 70 km/h. el pitido será de intensidad 2.

Si se da el síntoma de DISTANCIA INSEGURA se enciende la luz. En caso de DISTANCIA IMPRUDENTE se emite
un pitido de intensidad 3 y se enciende la luz.

En caso de producirse los síntomas de PELIGRO COLISIÓN y CABEZA INCLINADA simultáneamente se emite un
pitido de nivel 5 y se activa el freno del vehículo.

En todos los casos las acciones se mantienen hasta que desaparezca la situación de riesgo correspondiente. 

***
#### Notas
 *_workload_*: Se aloja en el fichero tools. Simula el retardo que puede sufrir un dispositivo a la hora de interactuar con el. 

*_Ravenscar_*: Es un paquete para controlar que el STR sea un sistema seguro. Aquí diremos que política de planificación  se usará en el sistema. 

En el paquete de dispositivos se alojará el código que define la funcionalidad de cada dispositivo.