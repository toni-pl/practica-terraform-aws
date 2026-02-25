# Practica Terraform AWS: Static Website en S3

Website estatico desplegado en Amazon S3 mediante Terraform. Crea un bucket en `eu-west-1` (Irlanda) con hosting estatico habilitado y acceso publico de lectura.

## Indice

- [Arquitectura](#arquitectura)
- [Requisitos](#requisitos)
- [Quickstart](#quickstart)
- [Configuracion](#configuracion)
- [Troubleshooting](#troubleshooting)
- [Notas de seguridad](#notas-de-seguridad)
- [Estructura](#estructura)

## Arquitectura

```
┌─────────────────────────────┐
│          Terraform          │
│                             │
│  module "s3_static_website" │
│  aws_s3_object (index.html) │
│  aws_s3_object (error.html) │
└────────────┬────────────────┘
             │ despliega
             ▼
┌─────────────────────────────┐
│        Amazon S3            │
│      eu-west-1 (Irlanda)    │
│                             │
│  ┌───────────────────────┐  │
│  │  Static Website Host  │  │
│  │  index.html           │  │
│  │  error.html           │  │
│  └───────────────────────┘  │
│                             │
│  Bucket Policy: GetObject   │
│  Public Access Block: off   │
└─────────────────────────────┘
             │
             ▼
  http://<bucket>.s3-website-eu-west-1.amazonaws.com
```

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado con credenciales validas (`aws configure`)
- Permisos IAM sobre S3 (crear bucket, bucket policy, objetos)

Comprueba que lo tienes listo:

```bash
terraform version
aws sts get-caller-identity
```

## Quickstart

1) Clona el repo y entra a la carpeta de despliegue:

```bash
git clone https://github.com/toni-pl/practica-terraform-aws
cd practica-terraform-aws/dev
```

2) Inicializa Terraform (descarga el provider de AWS):

```bash
terraform init
```

3) Revisa el plan antes de aplicar:

```bash
terraform plan
```

4) Despliega la infraestructura:

```bash
terraform apply
```

5) Copia el valor de `website_endpoint` del output y abrelo en una ventana de incognito.

Para destruir la infraestructura:

```bash
terraform destroy
```

## Configuracion

### Variables

Variables en `dev/variables.tf`:

| Variable | Descripcion | Default |
| --- | --- | --- |
| `aws_region` | Region AWS | `eu-west-1` |
| `bucket_name` | Nombre del bucket (debe ser unico globalmente) | `practica-final-toni-keepcoding-2026` |

### Outputs

Al finalizar el `apply`, Terraform muestra:

```
Outputs:

website_endpoint = "http://<bucket-name>.s3-website-eu-west-1.amazonaws.com"
bucket_name      = "<bucket-name>"
bucket_region    = "eu-west-1"
```

## Troubleshooting

- **`BucketAlreadyExists`**: el nombre del bucket ya esta en uso globalmente. Cambia `bucket_name` en `dev/variables.tf` por otro unico.
- **`AccessDenied` al aplicar**: las credenciales de AWS no tienen permisos suficientes sobre S3. Revisa la politica IAM del usuario.
- **El endpoint devuelve `403 Forbidden`**: espera unos segundos tras el `apply` y prueba en incognito. La propagacion de la bucket policy puede tardar un momento.
- **El endpoint devuelve `404`**: verifica que los objetos `index.html` y `error.html` se subieron correctamente (`terraform state list | grep aws_s3_object`).

## Notas de seguridad

- Este despliegue expone el bucket como website estatico con lectura publica. Es intencionado para la practica, pero no es apropiado para contenido sensible.
- Para entornos reales: considera CloudFront delante del bucket y bloquear acceso publico directo, logging, y controles de seguridad adicionales.

## Estructura

```
practica-terraform-aws/
├── dev/
│   ├── providers.tf        # Provider AWS
│   ├── variables.tf        # Region y nombre del bucket
│   ├── main.tf             # Modulo S3 + subida de ficheros HTML
│   ├── outputs.tf          # Endpoint del website
│   └── website/
│       ├── index.html      # Pagina principal
│       └── error.html      # Pagina de error 404
└── modules/
    └── aws/
        └── s3/
            ├── main.tf     # Recursos S3 para website estatico
            ├── variables.tf
            └── outputs.tf
```
