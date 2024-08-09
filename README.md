# jenkins-development-environment
A project for standing up the resources needed for working on a Jenkins class.

## The formulas
- Count of videos ready to record or done:
```
=COUNTif(B10:B9039,"=Ready") + COUNTif(B10:B9039,"*Done") & " videos ready to record or done"
```

- Percent of videos ready to record or done:
```
=(((COUNTif(B10:B9039,"=Ready") + COUNTif(B10:B9039,"=Done"))/COUNTA(C10:C9039)))
```
