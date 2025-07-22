# VPC balanceo de carga ☁
*IBM Cloud* proporciona dos tipos de equilibradores de carga para VPC: **Application Load Balancer para VPC (ALB)** y **Network Load Balancer para VPC (NLB)**. Estos equilibradores se pueden utilizar para distribuir el tráfico entre varias instancias de servidor dentro de la misma región de su VPC. 

*IBM Cloud* proporciona equilibradores de carga de aplicaciones públicos y privados. Un equilibrador de carga de aplicaciones proporciona equilibrio de carga de capa 7 (aplicación) y capa 4 (transporte) y da soporte a la descarga de SSL (Secure Sockets Layer). Los paquetes entrantes y salientes fluyen a través del equilibrador de carga.

Por otro lado, un equilibrador de carga de red solo proporciona equilibrio de carga de capa 4 en *IBM Cloud* y no admite la descarga de SSL.

La presente guía esta enfocada el despliegue de un ambiente demo para un balanceador de carga de aplicaciones. Adicionalmente, se indica el proceso que permite hacer solicitudes HTTP y monitorear el balanceador de carga.

<br />

<p align="center"><img width="700" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/DiagramaFinal.png"></p>
<br />

## Índice  📰
1. [Pre-Requisitos](#Pre-Requisitos-pencil)
2. [Crear y configurar un espacio de trabajo en IBM Cloud Schematics](#Crear-y-configurar-un-espacio-de-trabajo-en-IBM-Cloud-Schematics-gear)
3. [Configurar las variables de personalización de la plantilla de terraform](#Configurar-las-variables-de-personalización-de-la-plantilla-de-terraform-key)
4. [Generar y aplicar el plan de despliegue de los servidores VPC](#Generar-y-aplicar-el-plan-de-despliegue-de-los-servidores-VPC-hammer_and_wrench)
5. [Acceder al balanceador de carga y realizar solicitud HTTP](#Acceder-al-balanceador-de-carga-y-realizar-solicitud-HTTP-computer)
6. [Registro y monitoreo de balanceo de carga](#Registro-y-monitoreo-de-balanceo-de-carga-chart_with_upwards_trend)
7. [Referencias](#Referencias-mag)
8. [Autores](#Autores-black_nib)
<br />

## Pre Requisitos :pencil:
* Contar con una cuenta en <a href="https://cloud.ibm.com/"> IBM Cloud</a>.
* Contar con un grupo de recursos específico para el despliegue de los recursos.
* Haber creado una clave *SSH* en VPC dentro de la cuenta de IBM Cloud.
<br />

## Crear y configurar un espacio de trabajo en IBM Cloud Schematics :gear:
Para realizar el ejercicio lo primero que debe hacer es dirigirse al servicio de <a href="https://cloud.ibm.com/schematics/workspaces">IBM Cloud Schematics</a> y dar click en ```Crear espacio de trabajo +/Create workspace +```.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/1_Acceso.gif"></p>
<br />

Posteriormente, aparecerá una ventana en la que deberá diligenciar la siguiente información:
<br />

| VARIABLE | DESCRIPCIÓN |
| ------------- | :---: |
| URL del repositorio de GitHub | https://github.com/emeloibmco/VPC-balanceo-de-carga |
| Token de acceso  | (Opcional) Este parámetro solo es necesario para trabajar con repositorio privados |
| Versión de Terraform | terraform_v0.14 |
<br />

Presione ```Siguiente/Next```  ➡ Agregue un nombre para el espacio de trabajo ➡ Seleccione el grupo de recursos al que tiene acceso ➡ Seleccione una ubicación para el espacio de trabajo (recuerde que la ubicación determina dónde se ejecutarán las acciones del espacio de trabajo y no donde se desplegarán los recursos) y como opcional puede dar una descripción. Luego, de click en el botón ```Siguiente/Next```.

Una vez completos todos los campos puede presionar la opcion ```Crear/Create```.

<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/2_CrearWS.gif"></p>
<br />

## Configurar las variables de personalización de la plantilla de terraform :key:
Una vez  creado el espacio de trabajo, podrá ver el campo **VARIABLES**, en donde puede personalizar el espacio de trabajo. Allí debe ingresar la siguiente información:

* ```ssh_keyname```: coloque el nombre del *SSH* key que tendran las instancias de computo en el template. Habilite el campo ```sensitive``` para indicar que se trata de un valor sensible. Recuerde que esta *SSH* key debe estar desplegada en la region p-osa Osaka.   
* ```resource_group```: ingrese el nombre del grupo de recursos en el cual tiene permisos y donde quedaran agrupados todos los recursos que se aprovisionaran.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/3_ConfigurarVariables.gif"></p>
<br />

## Generar y aplicar el plan de despliegue de los servidores VPC :hammer_and_wrench:
Ya que estan todos los campos de personalización completos, debe ir hasta la parte superior de la ventana donde encontrara dos opciones, ```Generar plan/Generate plan``` y ```Aplicar plan/Apply plan```. Para continuar con el despliegue complete los siguientes pasos:

1. De click en ```Generar plan/Generate plan```: según su configuración, *Terraform* crea un plan de ejecución y describe las acciones que deben ejecutarse para llegar al estado que se describe en sus archivos de configuración de *Terraform*. Para determinar las acciones, *Schematics* analiza los recursos que ya están aprovisionados en su cuenta de *IBM Cloud* para brindarle una vista previa de si los recursos deben agregarse, modificarse o eliminarse. Puede revisar el plan de ejecución, cambiarlo o simplemente ejecutar el plan. Un vez se termina de generar el plan le debe salir como respuesta *Done with the workspace action*, tal y como se muestra en la siguiente imagen.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/4_GenerarPlan.gif"></p>
<br />

2. De click en ```Aplicar plan/Apply plan```: cuando esté listo para realizar cambios en su entorno de nube, puede aplicar sus archivos de configuración de *Terraform*. Para ejecutar las acciones que se especifican en sus archivos de configuración, *Schematics* utiliza el complemento *IBM Cloud* Provider para *Terraform*. Espere unos minutos mientras se completa el proceso. 
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/5_1_AplicarPlan.gif"></p>
<br />

Al final debe salir como respuesta *Done with the workspace action*, tal y como se muestra en la siguiente imagen.
<br /> 
<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/5_2_AplicarPlan.PNG"></p>
<br />

## Acceder al balanceador de carga y realizar solicitud HTTP :computer:
Para acceder al balanceador de carga implementado en el proceso anterior, realice lo siguiente:

1. De click en el ```Menú de navegación/Navigation menu``` ➡ ```Infraestructura VPC/VPC infrastructure```.

2. En la sección de ```Red/Network``` de click en la pestaña ```Equilibradores de carga/Load balancers```.

3. Tenga en cuenta la región en donde desplegó sus recursos y de click sobre el balanceador de carga que utilizará.

4. En la sección de ```IPs``` copie la primera IP que se muestra.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/6_LoadBalancer.gif"></p>
<br />

5. Coloque la IP en el navegador. Deberá visualizar como resultado la aplicación que se muestra en la imagen. Para realizar solicitudes de forma automática habilite la opción ```Auto refresh```.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/7_nginx.gif"></p>
<br />

## Registro y monitoreo de balanceo de carga :chart_with_upwards_trend:
Para monitorear y registrar de forma gráfica las solicitudes que se hacen al balanceador de carga, realice lo siguiente:

Nota:
  Se requiere la siguiente authorization entre ibmcloud monitoring y ibmcloud metrics routing

  <img width="813" height="733" alt="image" src="https://github.com/user-attachments/assets/13b22548-4ac0-4e9b-b48d-1ecf71abd715" />


1. Si no tiene agregado un servicio de monitoreo en el balanceador de carga:
   * Diríjase a la sección ```Vista previsa de supervisión/Monitoring preview```.
   * De click en el botón ```Agregar monitoreo/Add monitoring``` para agregar un servicio *IBM Cloud Monitoring*. 
     <br />

     <p align="center"><img width="400" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/AddMonitoring.PNG"></p>
     <br />
   
   * En la nueva ventana que aparece para la creación del servicio indique: la región donde está trabajando, el plan de precios (puede ser Lite), asigne un nombre exclusivo para        el servicio, seleccione el grupo de recursos, habilite la plataforma de métricas y para finalizar de click en el botón ```Crear/Create```.
     <br />
     
     <p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/AddMonitoring2.gif"></p>
     <br />

2. Si ya tiene agregado el servicio de monitoreo en el balanceador de carga:
   * Diríjase a la sección ```Vista previsa de supervisión/Monitoring preview```.
   * De click en el botón ```Iniciar supervisión/Launch monitoring```. 
   <br />

3. Espere mientras carga la ventana de monitoreo. Luego, podrá visualizar las métricas.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga-IMG/blob/master/Images/8_Monitoreo.gif"></p>
<br />

## Referencias :mag:
* <a href="https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics">Acerca de IBM Cloud Schematics</a>.
* <a href="https://cloud.ibm.com/docs/vpc?topic=vpc-nlb-vs-elb">Load balancers for VPC overview</a>.
<br />

## Autores :black_nib:
Equipo *IBM Cloud Tech Sales Colombia*.
<br />

