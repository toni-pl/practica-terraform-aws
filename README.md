# Práctica Final AWS - Bootcamp Keepcoding

Despliegue de un website estático en Amazon S3 mediante Terraform.

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

## Recursos desplegados

- **`aws_s3_bucket`** — Bucket S3 en `eu-west-1` (Irlanda)
- **`aws_s3_bucket_public_access_block`** — Desactiva el bloqueo de acceso público
- **`aws_s3_bucket_website_configuration`** — Habilita el hosting de website estático
- **`aws_s3_bucket_policy`** — Política pública de lectura (`s3:GetObject`)
- **`aws_s3_object`** — Sube `index.html` y `error.html` al bucket

## Uso

```bash
cd dev/
terraform init
terraform plan
terraform apply
```

## Output

Al finalizar el `apply`, Terraform muestra el endpoint del website:

```
Outputs:

website_endpoint = "http://<bucket-name>.s3-website-eu-west-1.amazonaws.com"
bucket_name      = "<bucket-name>"
bucket_region    = "eu-west-1"
```

> Abrir el endpoint en una ventana de incógnito para verificar el despliegue.

## Variables

| Variable | Descripción | Default |
|---|---|---|
| `aws_region` | Región AWS | `eu-west-1` |
| `bucket_name` | Nombre del bucket (debe ser único globalmente) | `practica-final-toni-keepcoding-2026` |

## Destruir la infraestructura

```bash
terraform destroy
```
