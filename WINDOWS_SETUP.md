# Configuración de Neovim en Windows

Esta guía te ayudará a replicar tu configuración de Neovim de macOS a Windows.

## Prerrequisitos

### 1. Instalar Chocolatey (Gestor de paquetes para Windows)

Abre PowerShell como Administrador y ejecuta:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### 2. Instalar Scoop (Alternativa para algunos paquetes)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

## Paquetes Requeridos

### Herramientas Básicas (Chocolatey)

```powershell
# Neovim
choco install neovim -y

# PowerShell 7+ (pwsh.exe - requerido para esta config)
choco install powershell-core -y

# Git
choco install git -y

# Node.js (requerido para LSP servers)
choco install nodejs -y

# Python (requerido para algunos plugins)
choco install python -y

# Ripgrep (búsqueda de archivos - usado por Telescope)
choco install ripgrep -y

# fd (búsqueda rápida de archivos - usado por Telescope)
choco install fd -y

# Nerd Font (para iconos en Neovim)
choco install firacode-ttf -y
# O descarga manualmente desde: https://www.nerdfonts.com/
```

### LSP Servers y Herramientas de Desarrollo

Después de instalar Node.js, instala los LSP servers con npm:

```powershell
# TypeScript/JavaScript LSP (CRÍTICO para Vue)
npm install -g @vtsls/language-server

# Vue Language Server
npm install -g @vue/language-server

# HTML LSP
npm install -g vscode-langservers-extracted

# CSS LSP
npm install -g vscode-langservers-extracted

# Emmet LSP
npm install -g @olrtg/emmet-language-server

# Prettier (formateador)
npm install -g prettier

# Vue TypeScript Plugin (requerido para vtsls con Vue)
npm install -g @vue/typescript-plugin
```

### Formatters (via Mason o npm)

```powershell
# Prettier ya instalado arriba

# Python formatters (si usas Python)
pip install black isort

# Lua formatter (opcional, se puede instalar via Mason)
choco install stylua -y
```

### Opcional: LazyGit (para integración Git)

```powershell
choco install lazygit -y
```

## Configuración de PowerShell

### 1. Configurar perfil de PowerShell

Edita tu perfil de PowerShell (opcional, pero recomendado):

```powershell
notepad $PROFILE
```

Agrega estas líneas para mejorar la experiencia:

```powershell
# Alias útiles
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim

# Mejorar la experiencia de PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
```

## Ubicación de la Configuración en Windows

Copia tu carpeta de configuración a:

```
%LOCALAPPDATA%\nvim\
# O en ruta completa:
C:\Users\TuUsuario\AppData\Local\nvim\
```

La estructura debe ser:

```
nvim\
├── init.lua
├── CLAUDE.md
├── WINDOWS_SETUP.md (este archivo)
├── lua\
│   ├── config\
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── lazy.lua
│   └── plugins\
│       ├── (todos tus plugins)
```

## Comandos Post-Instalación

Después de copiar la configuración y instalar las dependencias:

1. **Abrir Neovim por primera vez** (los plugins se instalarán automáticamente):
   ```powershell
   nvim
   ```

2. **Verificar salud de Neovim**:
   ```vim
   :checkhealth
   ```

3. **Instalar LSP servers adicionales** (si es necesario):
   ```vim
   :Mason
   ```

4. **Autenticar Codeium** (primera vez):
   ```vim
   :Codeium Auth
   ```

## Diferencias macOS vs Windows

### Equivalencias de herramientas instaladas con Brew

| macOS (Homebrew) | Windows (Chocolatey/Scoop) |
|------------------|----------------------------|
| `brew install neovim` | `choco install neovim` |
| `brew install node` | `choco install nodejs` |
| `brew install ripgrep` | `choco install ripgrep` |
| `brew install fd` | `choco install fd` |
| `brew install git` | `choco install git` |
| `brew install lazygit` | `choco install lazygit` |
| `brew install python` | `choco install python` |
| Font: Homebrew Cask | Manual o `choco install firacode-ttf` |

### Herramientas instaladas via npm (iguales en ambos)

```bash
npm install -g @vtsls/language-server
npm install -g @vue/language-server
npm install -g vscode-langservers-extracted
npm install -g @olrtg/emmet-language-server
npm install -g prettier
npm install -g @vue/typescript-plugin
```

### Python packages (iguales en ambos)

```bash
pip install black isort
```

## Configuración de la Terminal

Para mejor experiencia, configura tu terminal:

### Windows Terminal (Recomendado)

```powershell
choco install microsoft-windows-terminal -y
```

1. Abre Windows Terminal
2. Ve a Settings → Profiles → PowerShell
3. Configura:
   - Font face: "FiraCode Nerd Font" o tu Nerd Font preferida
   - Font size: 11-12
   - Color scheme: One Half Dark o tu preferida

### Configurar PowerShell como predeterminado

En Windows Terminal Settings → Startup → Default profile → PowerShell

## Solución de Problemas Comunes

### Error: "pwsh.exe no encontrado"

Asegúrate de instalar PowerShell Core:
```powershell
choco install powershell-core -y
```

### Error: LSP servers no funcionan

Verifica que Node.js esté en el PATH:
```powershell
node --version
npm --version
```

Reinstala los LSP servers:
```powershell
npm install -g @vtsls/language-server @vue/language-server vscode-langservers-extracted
```

### Iconos no se muestran correctamente

Instala una Nerd Font y configúrala en tu terminal:
- Descarga: https://www.nerdfonts.com/
- Instala la fuente (doble clic en el archivo .ttf)
- Configura tu terminal para usar esa fuente

### Prettier no formatea

Verifica instalación:
```powershell
prettier --version
```

Reinstala si es necesario:
```powershell
npm install -g prettier
```

## Script de Instalación Automatizado

Puedes crear un script `install.ps1` para automatizar la instalación:

```powershell
# install.ps1
# Ejecutar como administrador

# Instalar Chocolatey si no está instalado
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Instalar herramientas básicas
choco install neovim powershell-core git nodejs python ripgrep fd lazygit firacode-ttf -y

# Refrescar PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Instalar LSP servers y herramientas
npm install -g @vtsls/language-server @vue/language-server vscode-langservers-extracted @olrtg/emmet-language-server prettier @vue/typescript-plugin

# Instalar formatters Python
pip install black isort

Write-Host "Instalación completada. Copia tu configuración de Neovim a: $env:LOCALAPPDATA\nvim\" -ForegroundColor Green
```

Ejecuta el script como administrador:
```powershell
.\install.ps1
```

## Verificación Final

Después de completar toda la instalación, verifica:

```vim
:checkhealth
:LspInfo
:ConformInfo
:Mason
:Codeium Auth
```

Todo debería estar funcionando correctamente. ¡Disfruta de tu configuración de Neovim en Windows!
