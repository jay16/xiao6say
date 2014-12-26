# [小6语记]

## STARTUP 

````
bundle install
./unicorn {start|stop|restart}

bundle exec rake remote:deploy
````

## TODO

  1. C function extern into Ruby

## NOTES

  1. linux bash comand installed by hand, can execute in terminal but not script file

    `alias | grep COMMAND`

    add COMMAND basepath into env[PATH] in ~/.bash_profile.

    ````
    # ~/.bash_profile
    PATH="BASEPATH:$PATH"
    ````
    
    activate env[PATH].

    `source ~/.bash_profile`

    then script file will execute successfully.

    **not over**

    it's not ok when you execute bash code through ssh!

        + .bash_profile for user environment
        + .bashrc for bash environment, .bash_profile's substitute
      
## UPDATES

   1. 2014/12/26

     phantom's C code update.
