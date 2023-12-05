# <Apellidos> :<NIA>
# Solucion
using Images, ImageView

# 1. Lee las siguientes imágenes
img1 = # Leer cameraman en tonos de gris
img2 = # Leer peppers en colores

## Calcula su resolución Espacial
resE_img1 =
println("La resolución de la imagen 1 es", resE_img1)
resE_img2 =
println("La resolución de la imagen 2 es", resE_img2)

## Calcula el tamaño de las imágenes (en qué):
tamB_img1 =
println("El tamaño de la imagen 1 es", tamB_img1)
tamB_img2 =
println("El tamaño de la imagen 2 es", tamB_img2)

# 2. Pasa la imagen 2 a escala de grises
img2_g = 

# 3. Obtén los canales R, G y B por separado de la imagen img2
R_img2 =
G_img2 =
B_img2 =

# 4. Ecualizar linealmente la imagen img1 e img2_g: imY = (imX - mínimo(img1)) / (máximo(imX) - mínimo(imX))
img1_n =
img2_g_n =

# 5. Representa img1 y su correspondiente imagen ecualizada en 1x2. Pon títulos
using Plots

# 6. Representa img2 en escala de grises y su correspondiente imagen ecualizada en 1x2. Ponga títulos por subplot

# 7. Representa la imagen img2 a color

# 8. Representa en una figura 1x3 cada canal de la imagen img2

# 9. Reduce y muestra la imagen un factor de 10 con los métodos: el más cercano, bilineal, bicubica
img1_red1 =
img1_red2 =
img1_red3 =

# 10. Muestra las imágenes reducidas en una figura 1x3 con los métodos: el más cercano, bilineal, bicubica
img1_aug1 =
img1_aug2 =
img1_aug3 =
