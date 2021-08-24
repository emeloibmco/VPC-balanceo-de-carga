# VPC balanceo de carga ☁
*IBM® Cloud Schematics* 

La presente guía esta enfocada en crear el despliegue un ambiente demo de balanceo de carga con el fin de ver el proceso a realizar para habilitar el monitoreo de un balanceador de carga.
<br />

## Índice  📰
1. [Pre-Requisitos](#Pre-Requisitos-pencil)
2. [Crear y configurar un espacio de trabajo en IBM Cloud Schematics](#Crear-y-configurar-un-espacio-de-trabajo-en-IBM-Cloud-Schematics)
3. [Configurar las variables de personalización de la plantilla de terraform](#Configurar-las-variables-de-personalización-de-la-plantilla-de-terraform)
4. [Generar y aplicar el plan de despliegue de los servidores VPC](#Generar-y-aplicar-el-plan-de-despliegue-de-los-servidores-VPC)
5. [Acceder al balanceador de carga y realizar solicitud HTTP](#Acceder-al-balanceador-de-carga-y-realizar-solicitud-HTTP)
6. [Registro y monitoreo de balanceo de carga](#Registro-y-monitoreo-de-balanceo-de-carga)
7. [Referencias](#Referencias-mag)
8. [Autores](#Autores-black_nib)
<br />

## Pre Requisitos :pencil:
* Contar con una cuenta en <a href="https://cloud.ibm.com/"> IBM Cloud</a>.
* Contar con un grupo de recursos específico para el despliegue de los recursos.
* Haber creado una clave *SSH* en VPC dentro de la cuenta de IBM Cloud.
<br />

## Crear y configurar un espacio de trabajo en IBM Cloud Schematics
Para realizar el ejercicio lo primero que debe hacer es dirigirse al servicio de <a href="https://cloud.ibm.com/schematics/workspaces">IBM Cloud Schematics</a> y dar click en ```CREAR ESPACIO DE TRABAJO```.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/1_Acceso.gif"></p>
<br />

Posteriormente, aparecerá una ventana en la que deberá diligenciar la siguiente información:

| Variable | Descripción |
| ------------- | ------------- |
| URL del repositorio de GitHub | https://github.com/emeloibmco/VPC-balanceo-de-carga |
| Tocken de acceso  | (Opcional) Este parámetro solo es necesario para trabajar con repositorio privados |
| Version de Terraform | terraform_v0.14 |

Presione ```SIGUIENTE```  ➡ Agregue un nombre para el espacio de trabajo ➡ Seleccione el grupo de recursos al que tiene acceso ➡ Seleccione una ubicacion para el espacio de trabajo y como opcional puede dar una descripción. 

Una vez completos todos los campos puede presionar la opcion ``` CREAR```.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/2_CrearWS.gif"></p>
<br />

## Configurar las variables de personalización de la plantilla de terraform
Una vez  creado el espacio de trabajo, podra ver el campo VARIABLES que permite personalizar el espacio de trabajo allí debe ingresar la siguiente información:

* ```ssh_keyname```: Nombre del ssh key que tendran las instancias de computo en el template.
* ```resource_group```: Ingrese el nombre del grupo de recursos en el cual tiene permisos y donde quedaran agrupados todos los recursos que se aprovisionaran.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/3_ConfigurarVariables.gif"></p>
<br />

## Generar y aplicar el plan de despliegue de los servidores VPC
Ya que estan todos los campos de personalización completos, debe ir hasta la parte superior de la ventana donde encontrara dos opciones, Generar plan y Aplicar plan. Para continuar con el despliegue de los recursos debera presionar ```Generar Plan``` y una vez termine de generarse el plan ```Aplicar Plan```.

* ```Generar plan```: Según su configuración, Terraform crea un plan de ejecución y describe las acciones que deben ejecutarse para llegar al estado que se describe en sus archivos de configuración de Terraform. Para determinar las acciones, Schematics analiza los recursos que ya están aprovisionados en su cuenta de IBM Cloud para brindarle una vista previa de si los recursos deben agregarse, modificarse o eliminarse. Puede revisar el plan de ejecución, cambiarlo o simplemente ejecutar el plan.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/4_GenerarPlan.gif"></p>
<br />

* ```Aplicar plan```: Cuando esté listo para realizar cambios en su entorno de nube, puede aplicar sus archivos de configuración de Terraform. Para ejecutar las acciones que se especifican en sus archivos de configuración, Schematics utiliza el complemento IBM Cloud Provider para Terraform.
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/5_1_AplicarPlan.gif"></p>
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/5_2_AplicarPlan.PNG"></p>
<br />

## Acceder al balanceador de carga y realizar solicitud HTTP
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/6_LoadBalancer.gif"></p>
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/7_nginx.gif"></p>
<br />

## Registro y monitoreo de balanceo de carga
<br />

<p align="center"><img width="900" src="https://github.com/emeloibmco/VPC-balanceo-de-carga/blob/main/images/8_Monitoreo.gif"></p>
<br />

## Referencias :mag:
* <a href="https://cloud.ibm.com/docs/vpc?topic=vpc-getting-started">Getting started with Virtual Private Cloud (VPC)</a>.
* [Acerca de IBM Cloud Schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics).
<br />

## Autores :black_nib:
Equipo IBM Cloud Tech Sales Colombia.
<br />

