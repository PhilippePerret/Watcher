# Watcher

Utilitaire de travail pour surveiller un dossier et sauvegarder les nouveaux éléments régulièrement.

Le dossier à surveiller est défini dans `config.yaml`.

## Utilisation simple

* Faire une dossier `Current Work` sur le bureau,
* surveiller ce dossier dans `conflig.yaml`
  
  ~~~yaml
  ---
  # ...
  watched_folder: "/Users/moi/Current\ Work"
  ~~~

* définir l'heure où doit se faire l'opération

  ~~~yaml
  ---
  # ...
  every: day # ou week, month, year,
  at: 20:00
  ~~~

## Warnings

* Watcher ne tient compte que des éléments à sa racine, il ne fouille pas à l'intérieur des dossier,
* Le programme ne résout pas les aliases (les vrais aliases mac, pas les *symlinks*). Il ne faut mettre dans le dossier surveillé que des vrais éléments. Mais noter qu'il est idiot de faire des aliases pour Watcher puisque son principe même repose sur le système des aliases…
