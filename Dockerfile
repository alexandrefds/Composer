FROM php:8.2-fpm-alpine

# Instalar dependências
RUN apk add --no-cache shadow bash git curl

# Instalar Composer globalmente
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Remover diretório padrão do nginx
RUN rm -rf /var/www/html

# Criar novo projeto Laravel (ou apenas copiar seu código local)
RUN composer create-project --prefer-dist laravel/laravel .

# Ajustar permissões
RUN chown -R www-data:www-data /var/www

# Criar link simbólico para o diretório público
RUN ln -s public html

# Ajustar o ID do usuário para evitar problemas de permissões
RUN usermod -u 1000 www-data
USER www-data

EXPOSE 9000

ENTRYPOINT ["php-fpm"]
