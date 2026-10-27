# Proyecto 1: Infraestructura como código

Escenario con OpenTofu (libvirt) configurado con Ansible para desplegar
la aplicación guestbook_php (Apache + PHP + MariaDB).

## Despliegue

    cd opentofu && tofu init && tofu apply
    cd ../ansible && ansible-playbook site.yaml

(En construcción)
