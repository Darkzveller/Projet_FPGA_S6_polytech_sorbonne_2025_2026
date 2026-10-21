# Conception d’un processeur monocycle sur FPGA — Polytech Sorbonne

**Projet de VHDL comportemental | Spécialité Électronique et Informatique | Semestre 6 | 2025–2026**  
**Youssef EL KATTOUFI — Polytech Sorbonne, Sorbonne Université**

## Présentation du projet

Dans le cadre de ma formation d’ingénieur en Électronique et Informatique à Polytech Sorbonne, j’ai réalisé un projet de **conception, simulation et implémentation d’un processeur monocycle en VHDL** sur une carte **FPGA DE10-Lite**.

Le sujet proposait d'étudier deux types d'architectures, monocycle et multicycle, à partir d'un jeu d'instructions inspiré de l'**ARM7TDMI**. Pour ma part, j'ai choisi de concentrer le développement sur l'architecture **monocycle** afin de prendre le temps de concevoir, tester et assembler correctement les différents blocs du processeur. **La partie multicycle n'a donc pas été développée dans ce dépôt.**

L'objectif était de comprendre comment un processeur récupère une instruction en mémoire, la décode, sélectionne les opérandes, effectue une opération dans l'ALU et met à jour ses registres ou sa mémoire. Le système devait ensuite être validé par simulation avant d'être synthétisé et testé sur la carte.

Le processeur développé est une **implémentation pédagogique simplifiée**, et non une reproduction complète du jeu d'instructions ARM7TDMI.

## Matériel et logiciels utilisés

- **Carte FPGA :** Terasic DE10-Lite (FPGA Intel MAX 10, référence `10M50DAF484C7G`).
- **Langage :** VHDL.
- **ModelSim :** simulations, bancs de test et analyse des chronogrammes.
- **Intel Quartus Prime Lite :** compilation, synthèse, affectation des broches et programmation FPGA. Les fichiers de compilation archivés ont été produits avec la version **18.1**.
- **Git et GitHub :** suivi de l'historique et sauvegarde des différentes versions du projet.

## Arborescence du dépôt

J'ai organisé ce projet en séparant les **sources VHDL**, les **simulations**, la **partie Quartus Prime** et les **documents de travail**. Cette organisation m'a permis de tester les composants individuellement avant de les réunir au sein du processeur complet.

L'arborescence suivante reprend les principaux fichiers réellement présents dans le dépôt. Les fichiers temporaires générés par ModelSim ou Quartus ne sont pas tous détaillés.

```text
Projet_FPGA_S6_polytech_sorbonne_2025_2026/
│
├── src/                              # Composants et assemblage VHDL
│   ├── alu.vhd                       # ALU 32 bits et drapeaux N/Z
│   ├── banc_registre.vhd             # Banc de 16 registres de 32 bits
│   ├── mul_2_to_1.vhd                # Multiplexeur paramétrable
│   ├── sign_extension.vhd            # Extension de signe
│   ├── memory_data.vhd               # Mémoire de données (64 mots de 32 bits)
│   ├── datapath.vhd                  # Chemin de données et registre d'affichage
│   ├── instruction_memory.vhd        # Mémoire contenant le programme
│   ├── unit_gestion_instruction.vhd  # Compteur de programme et branchements
│   ├── decodeur.vhd                  # Décodage et signaux de contrôle
│   ├── SEVEN_SEG.vhd                 # Décodage pour les afficheurs 7 segments
│   ├── proc_mono_cycle.vhd           # Module principal du processeur
│   ├── reg_psr.vhd                   # Module de registre d'état conservé, non utilisé
│   └── Tableau_&_resultat.xlsx       # Tableau de travail
│
├── simu/                             # Bancs de test et scripts ModelSim
│   ├── tb_alu.vhd
│   ├── tb_datapath.vhd
│   ├── tb_datapathV2.vhd
│   ├── tb_decodeur.vhd
│   ├── tb_memory_data.vhd
│   ├── tb_mul_2_to_1.vhd
│   ├── tb_proc_mono_cycle.vhd        # Banc de test du processeur complet
│   ├── tb_reg_psr.vhd
│   ├── tb_sign_extension.vhd
│   ├── tb_unit_gestion_intruction.vhd
│   ├── simALU.do                     # Simulation de l'ALU
│   ├── simDECODEUR.do                # Simulation du décodeur
│   ├── simUGI.do                     # Simulation de l'unité d'instruction
│   ├── simuDATAPATHV2.do             # Simulation du chemin de données
│   ├── simPROC_MONOV2.do             # Simulation du processeur avec affichage
│   ├── simuPROC_MONO.do              # Version antérieure du script global
│   ├── *.do                          # Autres scripts de simulation
│   └── work/                         # Bibliothèque générée par ModelSim
│
├── fit/                              # Synthèse et implémentation Quartus
│   ├── Le_projet_complet/
│   │   ├── mono_multi_cycle.qpf      # Fichier de projet Quartus
│   │   ├── mono_multi_cycle.qsf      # Paramètres, sources et affectations des pins
│   │   ├── output_files/            # Rapports de compilation et fichiers FPGA
│   │   │   ├── mono_multi_cycle.sof  # Fichier de programmation FPGA
│   │   │   ├── mono_multi_cycle.fit.summary
│   │   │   └── ...
│   │   ├── db/                      # Base de données Quartus générée
│   │   └── incremental_db/          # Données de compilation incrémentale
│   ├── mono_multi_cycle.sof         # Copie du fichier de programmation
│   └── mono_multi_cycle.qws         # Espace de travail Quartus
│
├── Rapport/                          # Compte-rendu et documents de conception
│   ├── Rapport_FPGA_S6.pdf           # Rapport principal (37 pages)
│   ├── Rapport_FPGA_S6.docx          # Version modifiable du rapport
│   ├── Valeur_des_commandes.xlsx    # Tableau des signaux de contrôle
│   ├── Valeur_des_commandes.pdf
│   ├── banc_registre.md
│   ├── banc_registre.svg
│   ├── CPU.avif
│   └── Mise_en_forme_image.pptx
│
├── Docs/                             # Documentation technique
│   ├── DE10-Lite_User_Manual.pdf
│   └── Le_Bus_Serie_RS232.pdf
│
├── Projet_Processeur_MonoCycle_MultiCycle 2025.pdf  # Sujet du projet
├── Cours_Archi_ARM7TDMI.pdf         # Cours d'architecture ARM
├── Cours_Archi_mono-cycle_2024_v3.pdf
├── Archi_Multi-cycle_2025.pdf       # Support sur le multicycle
├── .gitignore
├── chemin_courant.bat
├── git_push.bat
└── README.md                         # Présentation du projet (ce fichier)
```

### Rôle des principaux dossiers

**[`src/`](src/)** contient le code VHDL du processeur. Les blocs sont écrits séparément pour pouvoir être vérifiés et corrigés indépendamment. Le module [`proc_mono_cycle.vhd`](src/proc_mono_cycle.vhd) assure l'assemblage final.

**[`simu/`](simu/)** regroupe les bancs de test (`tb_*.vhd`) ainsi que les scripts ModelSim (`*.do`). Ces scripts automatisent la compilation et organisent les signaux dans les chronogrammes. Plusieurs variantes de scripts ont été conservées au fil du développement.

**[`fit/Le_projet_complet/`](fit/Le_projet_complet/)** contient le projet Quartus Prime, les affectations des broches de la DE10-Lite et les résultats de compilation. Le nom `mono_multi_cycle` est celui du projet Quartus, même si le circuit effectivement développé est le **monocycle**.

**[`Rapport/`](Rapport/)** rassemble mon compte-rendu, les représentations des composants ainsi que les documents utilisés pour déterminer les signaux de contrôle.

**[`Docs/`](Docs/)** et les PDF présents à la racine regroupent le manuel de la carte, l'énoncé et les supports de cours utilisés pendant le projet.

## Architecture et fonctionnement du processeur

Le fonctionnement général repose sur trois ensembles reliés au sein du module principal :

1. **L'unité de gestion des instructions** : elle gère le compteur de programme (*Program Counter*, ou PC), lit l'instruction en mémoire et détermine l'adresse suivante.
2. **Le décodeur** : il interprète l'instruction et produit les signaux qui commandent les différents blocs.
3. **Le chemin de données (*datapath*)** : il rassemble les registres, l'ALU, les multiplexeurs, l'extension de signe et la mémoire de données.

À chaque cycle, l'instruction lue est transmise au décodeur. Celui-ci sélectionne les registres et les sources de données, puis autorise si nécessaire une opération dans l'ALU, une lecture ou écriture mémoire, ou un branchement.

### 1. Unité arithmétique et logique (ALU)

Le composant [`alu.vhd`](src/alu.vhd) effectue ses opérations sur **32 bits**. Son entrée `OP` de 2 bits choisit le traitement à réaliser :

| `OP` | Opération | Résultat |
| --- | --- | --- |
| `00` | Addition | `A + B` |
| `01` | Transfert de B | `B` |
| `10` | Soustraction | `A - B` |
| `11` | Transfert de A | `A` |

L'ALU génère également deux indicateurs : **N** (bit de signe du résultat) et **Z** (résultat nul). Ces indicateurs sont notamment utiles pour les comparaisons et les branchements conditionnels.

### 2. Banc de registres et mémoire de données

Le fichier [`banc_registre.vhd`](src/banc_registre.vhd) décrit **16 registres de 32 bits**, accessibles par deux ports de lecture et un port d'écriture. La lecture est asynchrone ; l'écriture est effectuée au front montant de l'horloge lorsque `WE` est actif.

La mémoire de données, définie dans [`memory_data.vhd`](src/memory_data.vhd), contient **64 mots de 32 bits**. Elle permet au programme de lire des valeurs, d'effectuer ses calculs et de sauvegarder son résultat.

### 3. Chemin de données (*datapath*)

Le module [`datapath.vhd`](src/datapath.vhd) relie le banc de registres, l'ALU, les multiplexeurs, l'extension de signe et la mémoire. Les signaux `ALUSrc`, `MemToReg`, `RegWr` et `MemWr` déterminent la circulation des données et les écritures autorisées.

J'ai également choisi d'intégrer directement dans ce module le **registre d'affichage de 32 bits**, commandé par `RegAff_en`, afin de conserver une architecture plus lisible.

### 4. Gestion des instructions et décodeur

L'unité [`unit_gestion_instruction.vhd`](src/unit_gestion_instruction.vhd) maintient le PC et lit les instructions stockées dans [`instruction_memory.vhd`](src/instruction_memory.vhd). Le décodeur [`decodeur.vhd`](src/decodeur.vhd) interprète un ensemble limité d'instructions inspirées d'ARM :

| Instruction | Fonction |
| --- | --- |
| `MOV` | Charger ou transférer une valeur dans un registre |
| `ADD` (registre ou immédiat) | Effectuer une addition |
| `CMP` | Comparer deux valeurs en mettant à jour les indicateurs d'état |
| `LDR` | Lire une valeur en mémoire |
| `STR` | Écrire une valeur en mémoire |
| `BAL` | Effectuer un branchement inconditionnel |
| `BLT` | Effectuer un branchement conditionnel selon le drapeau `N` dans cette implémentation |

Le traitement des branchements est adapté au **programme de démonstration** : il ne constitue pas une prise en charge générale de toutes les instructions et conditions ARM.

### 5. Affichage sur la DE10-Lite

Le module [`SEVEN_SEG.vhd`](src/SEVEN_SEG.vhd) convertit une valeur sur 4 bits en signaux destinés à un afficheur 7 segments.

Quatre instances pilotent les afficheurs `HEX0` à `HEX3` de la carte. Elles montrent les **16 bits de poids faible** de la valeur mémorisée dans le registre d'affichage. Le signal `Pol_HEX` permet d'adapter la polarité des segments.

## Programme de démonstration

Le programme de test est directement renseigné dans [`instruction_memory.vhd`](src/instruction_memory.vhd). Il permet de valider le fonctionnement du processeur complet :

1. Initialiser le registre `R1` à l'adresse `0x10` et le registre `R2` à zéro.
2. Lire successivement les valeurs présentes en mémoire à partir de l'adresse `0x10`.
3. Ajouter chaque valeur à l'accumulateur `R2`.
4. Incrémenter le pointeur `R1` et le comparer à `0x1A`.
5. Revenir dans la boucle tant que la condition du branchement `BLT` est satisfaite.
6. En fin de boucle, écrire le résultat dans la case mémoire `0x1A` avec `STR`, puis le présenter sur les afficheurs.
7. Revenir au début du programme avec `BAL`.

**Dans la version actuelle de `memory_data.vhd`**, les dix cases de `0x10` à `0x19` sont initialisées avec les valeurs de 1 à 10. La somme attendue est donc **55 en décimal**, soit **`0x0037`** en hexadécimal sur quatre chiffres. Le code et les valeurs utilisés pendant les essais ont évolué : certaines figures du rapport correspondent à d'autres jeux de données.

## Simulations sous ModelSim

J'ai d'abord travaillé par composants afin d'identifier plus facilement les erreurs. Les principaux blocs disposent de leur banc de test et d'un script `.do` associé. Les simulations permettent notamment d'observer les commandes de l'ALU, les lectures et écritures des registres, les accès mémoire, le comportement du PC et les signaux envoyés aux afficheurs.

Pour le processeur complet, les fichiers principaux sont :

- [`simu/tb_proc_mono_cycle.vhd`](simu/tb_proc_mono_cycle.vhd) : banc de test global.
- [`simu/simPROC_MONOV2.do`](simu/simPROC_MONOV2.do) : compilation des blocs, lancement de la simulation et organisation des chronogrammes avec les afficheurs `HEX0` à `HEX3`.
- [`simu/simuPROC_MONO.do`](simu/simuPROC_MONO.do) : script antérieur, conservé pour retracer le développement.

### Relancer la simulation

Dans ModelSim, ouvrir le répertoire `simu/` comme dossier de travail, puis exécuter :

```tcl
do simPROC_MONOV2.do
```

Le script compile les fichiers VHDL du dossier `src/`, lance `tb_proc_mono_cycle` puis prévoit une simulation sur **3 000 ns** pour afficher l'évolution du PC, des registres et du résultat.

**Remarque pour réutiliser l'archive :** les fichiers correspondent à plusieurs étapes du développement. Avant de relancer la simulation sur la version archivée, il faut vérifier la correspondance entre les ports du module principal et ceux du banc de test. Dans `tb_proc_mono_cycle.vhd`, les sorties `HEX0` à `HEX3` ne sont actuellement pas associées et doivent être connectées ou indiquées `open`. Le reset externe `RST` du module principal est **actif à l'état bas** : pour tester une véritable impulsion de remise à zéro, il faut le placer temporairement à `0` puis à `1`. Certains anciens scripts, comme `simuREG_AFF.do`, font également référence à des fichiers de test intermédiaires absents de l'archive. Ces précautions évitent de confondre les simulations présentées dans le rapport avec une relance automatique garantie sans adaptation.

## Implémentation sous Quartus Prime

Après le travail de conception et de simulation, j'ai préparé le processeur pour le FPGA à l'aide de Quartus Prime.

Le projet se trouve dans [`fit/Le_projet_complet/`](fit/Le_projet_complet/) :

- [`mono_multi_cycle.qpf`](fit/Le_projet_complet/mono_multi_cycle.qpf) : projet à ouvrir dans Quartus.
- [`mono_multi_cycle.qsf`](fit/Le_projet_complet/mono_multi_cycle.qsf) : sélection du circuit Intel MAX 10, déclaration des sources et affectations des broches.
- [`mono_multi_cycle.fit.summary`](fit/Le_projet_complet/output_files/mono_multi_cycle.fit.summary) : synthèse des ressources utilisées.
- [`mono_multi_cycle.sof`](fit/Le_projet_complet/output_files/mono_multi_cycle.sof) : fichier destiné à la programmation de la carte.

La compilation finale conservée dans le dépôt est indiquée comme **réussie** dans les rapports Quartus Prime 18.1. Le rapport de placement-routage fait notamment état de **3 116 éléments logiques** et de **2 327 registres dédiés** sur le circuit MAX 10.

Les captures des essais sur la carte FPGA sont présentées dans mon rapport, dans la section **« Preuve de fonctionnement sur FPGA »**.

**Attention aux chemins relatifs :** le projet Quartus est rangé dans `fit/Le_projet_complet/`, tandis que les sources sont au niveau racine dans `src/`. Si Quartus ne retrouve pas les fichiers VHDL référencés par le `.qsf`, il faut corriger leurs chemins relatifs en fonction de l'emplacement du projet (depuis `fit/Le_projet_complet/`, le dossier source est `../../src/`).

## Difficultés rencontrées

La principale difficulté a été de **faire correspondre ce que j'observais en simulation avec le résultat obtenu sur la carte**.

Lors des essais sous Quartus Prime, certaines compilations prenaient plusieurs minutes. J'ai consacré du temps à rechercher des erreurs dans le code et les signaux, alors qu'une partie du problème provenait finalement d'une **mauvaise affectation des broches d'un des afficheurs 7 segments**.

Pour identifier l'origine du problème, je suis revenu aux chronogrammes ModelSim afin de vérifier les valeurs calculées et les données présentes sur les signaux internes. J'ai ensuite corrigé la configuration des broches dans Quartus Prime et poursuivi les essais sur la DE10-Lite.

Ce projet m'a surtout permis de mieux comprendre l'importance de **valider chaque composant avant l'assemblage**, puis de distinguer les erreurs de logique VHDL des erreurs liées à l'implémentation matérielle.

## Documentation

- [Rapport complet du projet (PDF)](Rapport/Rapport_FPGA_S6.pdf) — conception, explication des modules, chronogrammes et preuves de fonctionnement sur FPGA.
- [Rapport modifiable (Word)](Rapport/Rapport_FPGA_S6.docx) — version de travail du compte-rendu.
- [Sujet du projet (PDF)](Projet_Processeur_MonoCycle_MultiCycle%202025.pdf) — cahier des charges monocycle et multicycle.
- [Tableau des commandes (PDF)](Rapport/Valeur_des_commandes.pdf) — commandes et signaux de contrôle du processeur.
- [Manuel de la DE10-Lite (PDF)](Docs/DE10-Lite_User_Manual.pdf) — documentation utilisée pour la carte et ses broches.
- [Sources du processeur](src/) — modules VHDL.
- [Bancs de test et scripts](simu/) — simulations ModelSim.

---

**Projet réalisé dans le cadre de l'enseignement de VHDL comportemental à Polytech Sorbonne — année universitaire 2025–2026.**
