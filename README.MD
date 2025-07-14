# DOCKER.SHIFT - Script de Realocação de Imagens Docker
[![](https://img.shields.io/badge/Terminal%20-%20Windows%20-%233776AB??style=for-the-badge&logo=codecrafters&labelColor=gray&logoColor=white)](#) 				 [![](https://img.shields.io/badge/Docker%20-%20Desktop%20-%233776AB??style=for-the-badge&logo=docker&labelColor=gray&logoColor=white)](#)

## Descrição

Este projeto se destina a versões do **Docker Desktop** que façam uso do **WSL ([Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/about))** em ambientes **Windows 10 ou superiores**. Ele oferece um script que automatiza o processo de migração da imagem WSL utilizada pelo Docker Desktop a partir do **VHDX** gerado pelo Docker Desktop **para outra unidade ou disco,** com o objetivo principal de **liberar espaço** na unidade original (tipicamente C:). 

Ele realiza a **movimentação completa da pasta de dados do WSL gerenciada pelo Docker Desktop** para um novo local especificado pelo usuário, **criando em seguida uma junção NTFS (link simbólico)** no caminho original que aponta para o novo destino. Dessa forma, **o sistema e o Docker Desktop continuam acessando os dados normalmente,** porém fisicamente os arquivos estarão **localizados na nova unidade.**

### <FONT color="#FFFC00">Este procedimento é recomendado para cenários em que o espaço disponível no disco original seja limitado, garantindo continuidade dos serviços sem perda de dados ou limitações. </FONT>


---

## Funcionalidades

1. Encerra os processos relacionados ao Docker Desktop e ao WSL para garantir que os arquivos estejam liberados para movimentação.
2. Define a distribuição `docker-desktop` como padrão do WSL (opcional, para quem utiliza múltiplas distribuições).
3. Cria o diretório de destino, caso ele ainda não exista.
4. Move o conteúdo completo da pasta `wsl` original para o novo diretório especificado, preservando todas as permissões e atributos dos arquivos.
5. Remove a pasta original (se possível) ou a renomeia caso ainda esteja em uso.
6. Cria uma junção NTFS (`mklink /J`) do diretório original apontando para o novo local, garantindo transparência para o sistema e aplicativos.

---

## Requisitos

- Sistema operacional: Windows 10 ou superior com suporte ao WSL.
- Privilégios de administrador para execução do script.
- Docker Desktop instalado e configurado com o WSL habilitado.
- Espaço suficiente no disco destino para alojar os arquivos da imagem WSL do Docker.

---

## Configuração

No início do script, configure as variáveis conforme sua necessidade:

- `SOURCE_DIR` - Caminho completo da pasta WSL atual utilizada pelo Docker Desktop. Exemplo:
```

C:\Users\Administrador\AppData\Local\Docker\wsl

```

- `TARGET_DIR` - Novo local onde a pasta `wsl` será movida. Exemplo:
```

D:\DockerData\DockerDesktopWSL

```

- `TARGET_PARENT` - Diretório pai do `TARGET_DIR`, que será criado caso não exista. Exemplo:
```

D:\DockerData

```

---

## Modo de uso

1. Após [configurar as variáveis iniciais](#configuracao). Execute o script `.cmd` com privilégios de administrador.
2. Aguarde a conclusão das etapas automáticas descritas pelo script.
3. Ao final, a pasta original estará substituída por uma junção simbólica apontando para o novo local dos dados.
4. O Docker Desktop e o WSL continuarão funcionando normalmente, utilizando a imagem no novo local.

---

## Observações importantes

- A distribuição `docker-desktop` é gerenciada internamente pelo Docker Desktop e sua alteração deve ser feita com cautela.
- O script tenta garantir que os processos que possam estar usando os arquivos sejam encerrados para evitar erros de acesso.
- Caso algum arquivo ou pasta esteja em uso, o script renomeia temporariamente a pasta original antes de criar a junção.
- Recomenda-se fazer backup dos dados importantes antes da execução do script para evitar perda acidental.
- **<FONT color="#FFFC00"> Após a execução, qualquer reinstalação ou atualização do Docker Desktop pode exigir que o processo seja repetido caso os dados voltem a ser recriados na unidade original. Basta executar o script novamente.</FONT>**

---

## Autor

**Sr. Victor Batista**  [t.me/LevyMac](https://t.me/LevyMac)




