# Explicación detallada del código

## index.html
1. `<!DOCTYPE html>` - Declara que el documento es HTML5.
2. `<html lang="es">` - Abre la página HTML especificando el idioma español.
3. `<head>` - Comienza la cabecera del documento.
4. `<meta charset="UTF-8" />` - Establece la codificación de caracteres a UTF-8.
5. `<meta name="viewport" content="width=device-width,initial-scale=1" />` - Hace que el diseño sea responsive en dispositivos móviles.
6. `<title>Despliegue AVD Simplificado</title>` - Título mostrado en la pestaña del navegador.
7. `<style>` - Inicio del bloque de estilos CSS.
8. `body { ... }` - Estilos básicos para el cuerpo de la página.
9. `label { ... }` - Estilos para las etiquetas de los campos.
10. `input, select, textarea { ... }` - Estilos para los controles de formulario.
11. `button { ... }` - Estilos para el botón de envío.
12. `</style>` - Fin del bloque de estilos.
13. `</head>` - Cierra la cabecera.
14. `<body>` - Inicio del cuerpo de la página.
15. `<h1>Formulario...` - Título principal del formulario.
16. `<p>Completa...` - Texto explicativo del funcionamiento.
17. *(línea en blanco)*
18. `<form id="avd-form">` - Inicio del formulario con identificador `avd-form`.
19. `<label for="resource_group_name">...` - Etiqueta para el campo de resource group.
20. `<input type="text" id="resource_group_name" ... />` - Campo para introducir el nombre del resource group.
21. `placeholder="RG-AVD-Prod" />` - Valor de ejemplo para el resource group.
22. *(línea en blanco)*
23. `<label for="host_pool_name">...` - Etiqueta para el host pool.
24. `<input type="text" id="host_pool_name" ... />` - Campo para el nombre del host pool.
25. `placeholder="AVD-Pool-Prod" />` - Valor de ejemplo para host pool.
26. *(línea en blanco)*
27. `<label for="total_users">...` - Etiqueta para número de usuarios.
28. `<input type="number" id="total_users" ... />` - Campo numérico para usuarios.
29. *(línea en blanco)*
30. `<label for="user_upns">...` - Etiqueta para los UPNs o grupos.
31. `<textarea id="user_upns" ...></textarea>` - Área de texto para UPNs/grupos.
32. `placeholder="usuario1@contoso.com,grupo-ventas"` - Ejemplo de valores.
33. *(línea en blanco)*
34. `<button type="submit">Desplegar AVD</button>` - Botón que envía el formulario.
35. `</form>` - Cierre del formulario.
36. *(línea en blanco)*
37. `<div id="status" ...></div>` - Contenedor para mensajes de éxito.
38. `<div id="error" ...></div>` - Contenedor para mensajes de error.
39. *(línea en blanco)*
40. `<script>` - Comienzo del bloque de script JavaScript.
41. `// 1) URL de tu Azure Function...` - Comentario explicativo.
42. `const FUNCTION_URL = "https://...";` - Dirección de la Azure Function a invocar.
43. *(línea en blanco)*
44. `// 2) Datos “fijos” del workflow en GitHub` - Comentario.
45. `const owner = "bucketto";` - Propietario del repositorio.
46. `const repo = "az-virtual-office";` - Nombre del repositorio de GitHub.
47. `const workflow_id = "avd-deploy.yml";` - Archivo del workflow a ejecutar.
48. `const ref = "main";` - Rama del repositorio donde se ejecutará.
49. *(línea en blanco)*
50. `document.getElementById("avd-form").addEventListener("submit", async function(e) {` - Maneja el envío del formulario.
51. `e.preventDefault();` - Evita el envío tradicional del formulario.
52. `document.getElementById("status").textContent = "";` - Limpia el mensaje de estado previo.
53. `document.getElementById("error").textContent = "";` - Limpia el mensaje de error previo.
54. *(línea en blanco)*
55. `// 3) Recoger valores del formulario` - Comentario.
56. `const formData = new FormData(e.target);` - Recoge los datos del formulario en un objeto FormData.
57. `const inputs = {};` - Objeto donde se almacenarán los valores.
58. `formData.forEach((value, key) => {` - Recorre cada campo del formulario.
59. `inputs[key] = value;` - Guarda cada par clave/valor en `inputs`.
60. `});` - Fin del bucle.
61. *(línea en blanco)*
62. `try {` - Inicio del bloque try para manejar errores.
63. `// 4) Llamar a tu Azure Function` - Comentario.
64. `const response = await fetch(FUNCTION_URL, {` - Realiza la petición HTTP a la función.
65. `method: "POST",` - Usa el método POST.
66. `headers: {` - Define cabeceras HTTP.
67. `"Accept": "application/json",` - Acepta respuestas JSON.
68. `"Content-Type": "application/json"` - Indica que enviamos JSON.
69. `},` - Fin de cabeceras.
70. `body: JSON.stringify({` - Construye el cuerpo de la petición.
71. `owner,` - Propietario del repo enviado a la función.
72. `repo,` - Nombre del repositorio.
73. `workflow_id,` - Workflow a despachar.
74. `ref,` - Rama objetivo.
75. `inputs` - Parámetros recopilados del formulario.
76. `})` - Fin de JSON.stringify.
77. `});` - Ejecuta la petición.
78. *(línea en blanco)*
79. `if (response.status === 204) {` - Comprueba que la función devolvió 204 (éxito).
80. `document.getElementById("status").textContent =` - Muestra mensaje de éxito.
81. `"Despliegue iniciado correctamente. Revisa GitHub Actions.";` - Texto mostrado.
82. `} else {` - Si no fue 204...
83. `const errJson = await response.json();` - Obtiene el detalle de error.
84. `document.getElementById("error").textContent =` - Muestra mensaje de error.
85. `"Error del backend: " + JSON.stringify(errJson);` - Texto con el error.
86. `}` - Fin del bloque else.
87. `} catch (err) {` - Captura cualquier excepción en la llamada fetch.
88. `document.getElementById("error").textContent = "Excepción: " + err.message;` - Muestra mensaje con la excepción.
89. `}` - Fin del bloque catch.
90. `});` - Cierra el manejador de submit.
91. `</script>` - Fin del bloque de script.
92. `</body>` - Cierre del cuerpo de la página.
93. `</html>` - Cierre del documento HTML.

## infra/variables.tf
1. `# Subscription id para terraform` - Comentario que describe la variable de suscripción.
2. `variable "subscription_id" {` - Inicio de la definición de la variable `subscription_id`.
3. `type        = string` - Tipo de dato string.
4. `description = "ID de la suscripción de Azure"` - Texto descriptivo.
5. `default     = "029f2df1-d292-4599-bcf2-03631b90c998"` - Valor por defecto de la suscripción.
6. `}` - Cierre de la variable.
7. *(línea en blanco)*
8. `# POST form variables` - Comentario que indica las variables recibidas por formulario.
9. *(línea en blanco)*
10. `variable "resource_group_name" {` - Nombre del resource group a crear.
11. `description = "Nombre del Resource Group donde se desplegará AVD"` - Explica su uso.
12. `type        = string` - Tipo string.
13. `}` - Fin de la variable.
14. *(línea en blanco)*
15. `variable "host_pool_name" {` - Variable para el nombre del host pool.
16. `description = "Nombre del Host Pool de AVD"` - Descripción.
17. `type        = string` - Tipo string.
18. `}` - Fin de la variable.
19. *(línea en blanco)*
20. `variable "total_users" {` - Cantidad total de usuarios simultáneos.
21. `description = "Número total de usuarios concurrentes..."` - Describe la variable.
22. `type        = number` - Tipo numérico.
23. `validation {` - Inicio del bloque de validación.
24. `condition     = var.total_users >= 1` - Asegura que sea al menos 1.
25. `error_message = "Debe haber al menos 1 usuario."` - Mensaje de error si no se cumple.
26. `}` - Fin de `validation`.
27. `}` - Fin de la variable.
28. *(línea en blanco)*
29. `variable "user_upns" {` - Variable para lista de UPNs o grupos.
30. `type = string` - Tipo string.
31. `description = "String con UPNs separados por comas..."` - Explica el formato esperado.
32. `default = ""` - Valor por defecto vacío.
33. `}` - Fin de la variable.

## infra/locals.tf
1. `locals {` - Inicio del bloque de valores locales de Terraform.
2. `session_hosts_count = (` - Definición de la variable local `session_hosts_count`.
3. `var.total_users % 2 == 0` - Comprueba si el número total de usuarios es par.
4. `? var.total_users / 2` - Si es par, divide por dos para saber cuántas VMs crear.
5. `: (floor(var.total_users / 2) + 1)` - Si es impar, redondea hacia arriba para obtener el número de VMs.
6. `)` - Cierre de la expresión.
7. `}` - Fin del bloque `locals`.

## infra/main.tf
1. `terraform {` - Bloque o expresión
2. `  required_providers {` - Bloque o expresión
3. `    azurerm = {` - Asigna azurerm
4. `      source  = "hashicorp/azurerm"` - Asigna source
5. `      version = ">= 3.0.0"` - Asigna version
6. `    }` - Bloque o expresión
7. `    azuread = {` - Asigna azuread
8. `      source  = "hashicorp/azuread"` - Asigna source
9. `      version = ">= 2.0.0"` - Asigna version
10. `    }` - Bloque o expresión
11. `  }` - Bloque o expresión
12. `}` - Bloque o expresión
13. `` - (línea en blanco)
14. `provider "azurerm" {` - Configuración del provider azurerm
15. `  subscription_id = var.subscription_id` - Asigna subscription_id
16. `  features {}` - Bloque o expresión
17. `}` - Bloque o expresión
18. `` - (línea en blanco)
19. `provider "azuread" {` - Configuración del provider azuread
20. `}` - Bloque o expresión
21. `` - (línea en blanco)
22. `################################################################################` - 
23. `# 1. Resource Group` - 1. Resource Group
24. `################################################################################` - 
25. `` - (línea en blanco)
26. `resource "azurerm_resource_group" "rg" {` - Define recurso azurerm_resource_group llamado rg
27. `  name     = var.resource_group_name` - Asigna name
28. `  location = "westeurope"` - Asigna location
29. `  tags = {` - Asigna tags
30. `    Proyecto = "AVD"` - Asigna Proyecto
31. `    Entorno  = "Produccion"` - Asigna Entorno
32. `  }` - Bloque o expresión
33. `}` - Bloque o expresión
34. `` - (línea en blanco)
35. `################################################################################` - 
36. `# 2. VNet y Subnet (nombres fijos)` - 2. VNet y Subnet (nombres fijos)
37. `################################################################################` - 
38. `` - (línea en blanco)
39. `resource "azurerm_virtual_network" "vnet" {` - Define recurso azurerm_virtual_network llamado vnet
40. `  name                = "vnet-avd"` - Asigna name
41. `  resource_group_name = azurerm_resource_group.rg.name` - Definición de recurso
42. `  location            = azurerm_resource_group.rg.location` - Asigna location
43. `  address_space       = ["10.0.0.0/16"]` - Asigna address_space
44. `  tags                = azurerm_resource_group.rg.tags` - Asigna tags
45. `}` - Bloque o expresión
46. `` - (línea en blanco)
47. `resource "azurerm_subnet" "subnet" {` - Define recurso azurerm_subnet llamado subnet
48. `  name                 = "subnet-avd"` - Asigna name
49. `  resource_group_name  = azurerm_resource_group.rg.name` - Definición de recurso
50. `  virtual_network_name = azurerm_virtual_network.vnet.name` - Asigna virtual_network_name
51. `  address_prefixes     = ["10.0.1.0/24"]` - Asigna address_prefixes
52. `}` - Bloque o expresión
53. `` - (línea en blanco)
54. `################################################################################` - 
55. `# 3. Storage Account + Fileshare para FSLogix (oculto al usuario)` - 3. Storage Account + Fileshare para FSLogix (oculto al usuario)
56. `################################################################################` - 
57. `` - (línea en blanco)
58. `resource "random_string" "suffix" {` - Define recurso random_string llamado suffix
59. `  length  = 4` - Asigna length
60. `  upper   = false` - Asigna upper
61. `  special = false` - Asigna special
62. `}` - Bloque o expresión
63. `` - (línea en blanco)
64. `resource "azurerm_storage_account" "sa" {` - Define recurso azurerm_storage_account llamado sa
65. `  name                     = format("stfsavdpool%s", random_string.suffix.result)` - Asigna name
66. `  resource_group_name      = azurerm_resource_group.rg.name` - Definición de recurso
67. `  location                 = azurerm_resource_group.rg.location` - Asigna location
68. `  account_tier             = "Standard"` - Asigna account_tier
69. `  account_replication_type = "LRS"` - Asigna account_replication_type
70. `  account_kind             = "StorageV2"` - Asigna account_kind
71. `  tags                     = azurerm_resource_group.rg.tags` - Asigna tags
72. `}` - Bloque o expresión
73. `` - (línea en blanco)
74. `resource "azurerm_storage_share" "fslogix" {` - Define recurso azurerm_storage_share llamado fslogix
75. `  name               = "fslogix-profiles"` - Asigna name
76. `  storage_account_id = azurerm_storage_account.sa.id` - Asigna storage_account_id
77. `  quota              = 50` - Asigna quota
78. `}` - Bloque o expresión
79. `` - (línea en blanco)
80. `################################################################################` - 
81. `# 4. Host Pool (siempre Pooled) con AAD Join + Intune Enrollment` - 4. Host Pool (siempre Pooled) con AAD Join + Intune Enrollment
82. `################################################################################` - 
83. `` - (línea en blanco)
84. `resource "azurerm_virtual_desktop_host_pool" "hostpool" {` - Define recurso azurerm_virtual_desktop_host_pool llamado hostpool
85. `  name                     = var.host_pool_name` - Asigna name
86. `  location                 = azurerm_resource_group.rg.location` - Asigna location
87. `  resource_group_name      = azurerm_resource_group.rg.name` - Definición de recurso
88. `  friendly_name            = var.host_pool_name` - Asigna friendly_name
89. `  validate_environment     = false` - Asigna validate_environment
90. `  custom_rdp_properties    = "targetisaadjoined:i:1;enrollvmwithintune:i:1"` - Asigna custom_rdp_properties
91. `  load_balancer_type       = "DepthFirst"` - Asigna load_balancer_type
92. `  type                     = "Pooled"` - Asigna type
93. `  maximum_sessions_allowed = 2` - Asigna maximum_sessions_allowed
94. `  tags                     = azurerm_resource_group.rg.tags` - Asigna tags
95. `}` - Bloque o expresión
96. `` - (línea en blanco)
97. `################################################################################` - 
98. `# 5. Application Group + Workspace` - 5. Application Group + Workspace
99. `################################################################################` - 
100. `` - (línea en blanco)
101. `resource "azurerm_virtual_desktop_application_group" "appgroup" {` - Define recurso azurerm_virtual_desktop_application_group llamado appgroup
102. `  name                = "${var.host_pool_name}-ag"` - Asigna name
103. `  location            = azurerm_resource_group.rg.location` - Asigna location
104. `  resource_group_name = azurerm_resource_group.rg.name` - Definición de recurso
105. `  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id` - Asigna host_pool_id
106. `  type                = "RemoteApp"` - Asigna type
107. `  tags                = azurerm_resource_group.rg.tags` - Asigna tags
108. `}` - Bloque o expresión
109. `` - (línea en blanco)
110. `resource "azurerm_virtual_desktop_workspace" "workspace" {` - Define recurso azurerm_virtual_desktop_workspace llamado workspace
111. `  name                = "${var.host_pool_name}-ws"` - Asigna name
112. `  location            = azurerm_resource_group.rg.location` - Asigna location
113. `  resource_group_name = azurerm_resource_group.rg.name` - Definición de recurso
114. `  friendly_name       = "${var.host_pool_name} Workspace"` - Asigna friendly_name
115. `  tags                = azurerm_resource_group.rg.tags` - Asigna tags
116. `}` - Bloque o expresión
117. `` - (línea en blanco)
118. `resource "azurerm_virtual_desktop_workspace_application_group_association" "assoc" {` - Define recurso azurerm_virtual_desktop_workspace_application_group_association llamado assoc
119. `  application_group_id = azurerm_virtual_desktop_application_group.appgroup.id` - Asigna application_group_id
120. `  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id` - Asigna workspace_id
121. `}` - Bloque o expresión
122. `` - (línea en blanco)
123. `################################################################################` - 
124. `# 6. Lookup de UPN ➔ Object ID (para cada UPN o grupo en var.user_upns)` - 6. Lookup de UPN ➔ Object ID (para cada UPN o grupo en var.user_upns)
125. `################################################################################` - 
126. `` - (línea en blanco)
127. `data "azuread_user" "lookup_user" {` - Definición de data source azuread_user lookup_user
128. `  # Si user_upns está vacío, usamos un set vacío ({}).` - Si user_upns está vacío, usamos un set vacío ({}).
129. `  # Si viene uno o varios UPNs separados por comas, hacemos split() y luego toset()` - Si viene uno o varios UPNs separados por comas, hacemos split() y luego toset()
130. `  for_each = var.user_upns == "" ? toset([]) : toset(split(",", var.user_upns))` - Asigna for_each
131. `  user_principal_name = each.value` - Asigna user_principal_name
132. `}` - Bloque o expresión
133. `` - (línea en blanco)
134. `################################################################################` - 
135. `# 7. Asignar rol "Desktop Virtualization User" a cada principal` - 7. Asignar rol "Desktop Virtualization User" a cada principal
136. `################################################################################` - 
137. `` - (línea en blanco)
138. `resource "azurerm_role_assignment" "avd_user_role" {` - Define recurso azurerm_role_assignment llamado avd_user_role
139. `  for_each             = data.azuread_user.lookup_user` - Asigna for_each
140. `  scope                = azurerm_virtual_desktop_application_group.appgroup.id` - Asigna scope
141. `  role_definition_name = "Desktop Virtualization User"` - Asigna role_definition_name
142. `  principal_id         = each.value.object_id` - Asigna principal_id
143. `` - (línea en blanco)
144. `  # Opcional: asegurarse de no crear el role assignment antes que el appgroup` - Opcional: asegurarse de no crear el role assignment antes que el appgroup
145. `  depends_on = [` - Asigna depends_on
146. `    azurerm_virtual_desktop_application_group.appgroup` - Bloque o expresión
147. `  ]` - Bloque o expresión
148. `}` - Bloque o expresión
149. `` - (línea en blanco)
150. `################################################################################` - 
151. `# 8. Crear NICs para las Session Hosts` - 8. Crear NICs para las Session Hosts
152. `################################################################################` - 
153. `` - (línea en blanco)
154. `resource "azurerm_network_interface" "nic" {` - Define recurso azurerm_network_interface llamado nic
155. `  count               = local.session_hosts_count` - Asigna count
156. `  name                = "${var.host_pool_name}-nic-${count.index + 1}"` - Asigna name
157. `  location            = azurerm_resource_group.rg.location` - Asigna location
158. `  resource_group_name = azurerm_resource_group.rg.name` - Definición de recurso
159. `` - (línea en blanco)
160. `  ip_configuration {` - Bloque o expresión
161. `    name                          = "ipconfig${count.index + 1}"` - Asigna name
162. `    subnet_id                     = azurerm_subnet.subnet.id` - Asigna subnet_id
163. `    private_ip_address_allocation = "Dynamic"` - Asigna private_ip_address_allocation
164. `  }` - Bloque o expresión
165. `` - (línea en blanco)
166. `  tags = azurerm_resource_group.rg.tags` - Asigna tags
167. `}` - Bloque o expresión
168. `` - (línea en blanco)
169. `################################################################################` - 
170. `# 9. Password aleatorio para el administrador local (si se quiere usar)` - 9. Password aleatorio para el administrador local (si se quiere usar)
171. `################################################################################` - 
172. `` - (línea en blanco)
173. `resource "random_password" "admin_pass" {` - Define recurso random_password llamado admin_pass
174. `  length  = 16` - Asigna length
175. `  special = true` - Asigna special
176. `}` - Bloque o expresión
177. `` - (línea en blanco)
178. `################################################################################` - 
179. `# 10. Sesión Hosts (Windows) con AAD Login y extensión` - 10. Sesión Hosts (Windows) con AAD Login y extensión
180. `################################################################################` - 
181. `` - (línea en blanco)
182. `resource "azurerm_windows_virtual_machine" "session_host" {` - Define recurso azurerm_windows_virtual_machine llamado session_host
183. `  count               = local.session_hosts_count` - Asigna count
184. `  name                = "${var.host_pool_name}-${count.index + 1}"` - Asigna name
185. `  resource_group_name = azurerm_resource_group.rg.name` - Definición de recurso
186. `  location            = azurerm_resource_group.rg.location` - Asigna location
187. `  size                = "Standard_D2s_v3"` - Asigna size
188. `  network_interface_ids = [` - Asigna network_interface_ids
189. `    azurerm_network_interface.nic[count.index].id` - Bloque o expresión
190. `  ]` - Bloque o expresión
191. `` - (línea en blanco)
192. `  os_disk {` - Bloque o expresión
193. `    caching              = "ReadWrite"` - Asigna caching
194. `    storage_account_type = "Standard_LRS"` - Asigna storage_account_type
195. `    disk_size_gb         = 127` - Asigna disk_size_gb
196. `  }` - Bloque o expresión
197. `` - (línea en blanco)
198. `  source_image_reference {` - Bloque o expresión
199. `    publisher = "MicrosoftWindowsDesktop"` - Asigna publisher
200. `    offer     = "Windows-10"` - Asigna offer
201. `    sku       = "win10-22h2-ent-g2"` - Asigna sku
202. `    version   = "latest"` - Asigna version
203. `  }` - Bloque o expresión
204. `` - (línea en blanco)
205. `  admin_username = "azureuser"` - Asigna admin_username
206. `  admin_password = random_password.admin_pass.result` - Asigna admin_password
207. `` - (línea en blanco)
208. `  identity {` - Bloque o expresión
209. `    type = "SystemAssigned"` - Asigna type
210. `  }` - Bloque o expresión
211. `` - (línea en blanco)
212. `  tags = azurerm_resource_group.rg.tags` - Asigna tags
213. `}` - Bloque o expresión
214. `` - (línea en blanco)
215. `resource "azurerm_virtual_machine_extension" "aad_login" {` - Define recurso azurerm_virtual_machine_extension llamado aad_login
216. `  count                       = local.session_hosts_count` - Asigna count
217. `  name                        = "AADLoginForWindows-${count.index + 1}"` - Asigna name
218. `  virtual_machine_id          = azurerm_windows_virtual_machine.session_host[count.index].id` - Asigna virtual_machine_id
219. `  publisher                   = "Microsoft.Azure.ActiveDirectory"` - Asigna publisher
220. `  type                        = "AADLoginForWindows"` - Asigna type
221. `  type_handler_version        = "1.0"` - Asigna type_handler_version
222. `  auto_upgrade_minor_version  = true` - Asigna auto_upgrade_minor_version
223. `}` - Bloque o expresión
224. `` - (línea en blanco)
225. `################################################################################` - 
226. `# 11. Outputs` - 11. Outputs
227. `################################################################################` - 
228. `` - (línea en blanco)
229. `output "host_pool_id" {` - Bloque o expresión
230. `  description = "ID del Host Pool creado"` - Asigna description
231. `  value       = azurerm_virtual_desktop_host_pool.hostpool.id` - Asigna value
232. `}` - Bloque o expresión
233. `` - (línea en blanco)
234. `output "session_hosts" {` - Bloque o expresión
235. `  description = "Lista de nombres de los session hosts"` - Asigna description
236. `  value       = [for vm in azurerm_windows_virtual_machine.session_host : vm.name]` - Asigna value
237. `}` - Bloque o expresión

## README.md
1. `# az-virtual-office` - Título del repositorio mostrado en Markdown.
