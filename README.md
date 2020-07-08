# doc_maker
## Description 
This is a small perl project which extract the comments above your function and create a MarkDown file with it. It only work with python file for now

Exemple :

```
# This is documentation, I am explaining things and people thank me about it
# It's a long comment because
# I need to say things
def my_function (arg1:int, arg2:int) :
  { the code }

```

Doc_maker extract the comments above the function signature and the signature itself.
Then it produces a README.md as :

# Filename
## my_function
`def my_function (arg1:int, arg2:int)`

This is documentation, I am explaining things and people thank me about it

It's a long comment because

I need to say things

## How to use it

`perl doc_maker.pl filepath`

with filepath having this format : "folder/folder/.../my_file"
