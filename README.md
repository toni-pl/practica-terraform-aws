# Práctica Final AWS - Bootcamp Keepcoding

Website estático desplegado en Amazon S3 mediante Terraform. El bucket se crea en `eu-west-1` (Irlanda) con acceso público de lectura y hosting estático habilitado.

## Índice

- [Arquitectura](#arquitectura)
- [Requisitos](#requisitos)
- [Quickstart](#quickstart)
- [Variables](#variables)
- [Outputs](#outputs)
- [Troubleshooting](#troubleshooting)
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

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configurado con credenciales válidas (`aws configure`)
- Permisos IAM sobre S3 (crear bucket, bucket policy, objetos)

Comprueba que lo tienes listo:

```bash
terraform version
aws sts get-caller-identity
```

## Quickstart

1. Clona el repositorio y entra a la carpeta de despliegue:

```bash
git clone https://github.com/toni-pl/practica-terraform-aws
cd practica-terraform-aws/dev
```

2. Inicializa Terraform (descarga el provider de AWS):

```bash
terraform init
```

3. Revisa el plan antes de aplicar:

```bash
terraform plan
```

4. Despliega la infraestructura:

```bash
terraform apply
```

5. Copia el valor de `website_endpoint` del output y ábrelo en una ventana de incógnito.

Para destruir la infraestructura:

```bash
terraform destroy
```

## Variables

| Variable | Descripción | Default |
| --- | --- | --- |
| `aws_region` | Región AWS | `eu-west-1` |
| `bucket_name` | Nombre del bucket (debe ser único globalmente) | `practica-final-toni-keepcoding-2026` |

## Outputs

Al finalizar el `apply`, Terraform muestra:

```
Outputs:

website_endpoint = "http://<bucket-name>.s3-website-eu-west-1.amazonaws.com"
bucket_name      = "<bucket-name>"
bucket_region    = "eu-west-1"
```

## Troubleshooting

- **`BucketAlreadyExists`**: el nombre del bucket ya está en uso globalmente. Cambia `bucket_name` en `variables.tf` por otro único.
- **`AccessDenied` al aplicar**: las credenciales de AWS no tienen permisos suficientes sobre S3. Revisa la política IAM del usuario.
- **El endpoint devuelve `403 Forbidden`**: espera unos segundos tras el `apply` y prueba en incógnito. La propagación de la bucket policy puede tardar un momento.
- **El endpoint devuelve `404`**: verifica que los objetos `index.html` y `error.html` se subieron correctamente (`terraform state list | grep aws_s3_object`).

## Estructura

```
practica-final/
├── dev/
│   ├── providers.tf        # Provider AWS (versión > 5.0)
│   ├── variables.tf        # Región y nombre del bucket
│   ├── main.tf             # Módulo S3 + subida de ficheros HTML
│   ├── outputs.tf          # Endpoint del website
│   └── website/
│       ├── index.html      # Página principal
│       └── error.html      # Página de error 404
└── modules/
    └── aws/
        └── s3/
            ├── main.tf     # Recursos S3 para website estático
            ├── variables.tf
            └── outputs.tf
```
