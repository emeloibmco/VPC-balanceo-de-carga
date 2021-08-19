# VPC balanceo de carga ☁
*IBM® Cloud Schematics* 

La presente guía esta enfocada en crear el despliegue un ambiente demo de balanceo de carga con el fin de ver el proceso a realizar para habilitar el monitoreo de un balanceador de carga

## Índice  📰
1. [Pre-Requisitos](#Pre-Requisitos-pencil)
2. [Crear una instancia de servicion de IBM Cloud Monitoring](#Crear_una_instancia_de_servicion_de_IBM_Cloud_Monitoring)
3. [Crear y configurar un espacio de trabajo en IBM Cloud Schematics](#Crear-y-configurar-un-espacio-de-trabajo-en-IBM-Cloud-Schematics)
4. [Configurar las variables de personalización de la plantilla de terraform](#Configurar-las-variables-de-personalización-de-la-plantilla-de-terraform)
5. [Generar y Aplicar el plan de despliegue de los servidores VPC](#Generar-y-apicar-el-plan-de-despliegue-de-los-servidores-VPC)
6. [Autores](#Autores-black_nib)
<br />

## Pre Requisitos :pencil:
* Contar con una cuenta en <a href="https://cloud.ibm.com/"> IBM Cloud</a>.
* Contar con un grupo de recursos específico para el despliegue de los recursos
* Haber creado una llave ssh en VPC dentro de la cuenta de IBM Cloud

## Crear una instancia de servicion de IBM Cloud Monitoring



## Crear y configurar un espacio de trabajo en IBM Cloud Schematics
Para realizar el ejercicio lo primero que debe hacer es dirigirse al servicio de <a href="https://cloud.ibm.com/schematics/workspaces">IBM Cloud Schematics</a> y dar click en ```CREAR ESPACIO DE TRABAJO```, una vez hecho esto aparecera una ventana en la que debera diligenciar la siguiente información.

| Variable | Descripción |
| ------------- | ------------- |
| URL del repositorio de Gi  | https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics |
| Tocken de acceso  | "(Opcional) Este parametro solo es necesario para trabajar con repositorio privados"  |
| Version de Terraform | terraform_v0.14 |

Presione ```SIGUIENTE```  > Agregue un nombre para el espacio de trabajo > Seleccione el grupo de recursos al que tiene acceso > Seleccione una ubicacion para el espacio de trabajo y como opcional puede dar una descripción. 

Una vez completos todos los campos puede presionar la opcion ``` CREAR```.

## Configurar las variables de personalización de la plantilla de terraform
Una vez  creado el espacio de trabajo, podra ver el campo VARIABLES que permite personalizar el espacio de trabajo allí debe ingresar la siguiente información:

* ```ssh_keyname```: Nombre del ssh key que tendran las instancias de computo en el template
* ```resource_group```: Ingrese el nombre del grupo de recursos en el cual tiene permisos y donde quedaran agrupados todos los recursos que se aprovisionaran.


## Generar y Aplicar el plan de despliegue de los servidores VPC
Ya que estan todos los campos de personalización completos, debe ir hasta la parte superior de la ventana donde encontrara dos opciones, Generar plan y Aplicar plan. Para continuar con el despliegue de los recursos debera presionar ```Generar Plan``` y una vez termine de generarse el plan ```Aplicar Plan```.

* ```Generar plan```: Según su configuración, Terraform crea un plan de ejecución y describe las acciones que deben ejecutarse para llegar al estado que se describe en sus archivos de configuración de Terraform. Para determinar las acciones, Schematics analiza los recursos que ya están aprovisionados en su cuenta de IBM Cloud para brindarle una vista previa de si los recursos deben agregarse, modificarse o eliminarse. Puede revisar el plan de ejecución, cambiarlo o simplemente ejecutar el plan
* ```resource_group```: Cuando esté listo para realizar cambios en su entorno de nube, puede aplicar sus archivos de configuración de Terraform. Para ejecutar las acciones que se especifican en sus archivos de configuración, Schematics utiliza el complemento IBM Cloud Provider para Terraform.

# Referencias 📖

* [Acerca de IBM Cloud Schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics).

