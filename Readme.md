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
