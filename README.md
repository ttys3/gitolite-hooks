# gitolite-hooks
usefull gitolite hooks


-------------------------------------------------------------------------------
## copied from gitolite man

## hooks

Note: the main documentation for this feature starts [here][hooks].

[hooks]: non-core#hooks-and-gitolite

### adding your own update hooks

You have some update hooks (for example crlf checking) that you want to
include in gitolite.  Assuming the hook itself is tested and works as a normal
**git** update hook does (i.e., conforms to what `man githooks` says an update
hook should do), here's how to do this:

1.  add this line in the rc file, within the `%RC` block, if it's not already
    present, or uncomment it if it's already present and commented out:

        LOCAL_CODE => "$ENV{HOME}/local",

2.  copy your update hook to a subdirectory called VREF under this directory,
    giving it a suitable name (let's say "crlf"):

        # log on to gitolite hosting user on the server, then:
        cd $HOME
        mkdir -p local/VREF
        git clone https://github.com/ttys3/gitolite-hooks.git
        cp ./gitolite-hooks/hooks/update/update-reject-crlf.sh local/VREF/crlf
        chmod +x local/VREF/crlf

3.  in your gitolite-admin clone, edit conf/gitolite.conf and
    add lines like this:

            -   VREF/crlf       =   @all

    to each repo that should have that "update" hook.

    Alternatively, you can simply add this at the end of the
    gitolite.conf file:

    ```gitolite
    repo @all
        -   VREF/crlf       =   @all
    ```

    Either way, add/commit/push the change to the gitolite-admin repo.

### adding other (non-update) hooks

Say you want other hooks, like a post-receive hook.  Here's how:

1.  add this line in the rc file, within the `%RC` block, if it's not already
    present, or uncomment it if it's already present and commented out:

        LOCAL_CODE => "$ENV{HOME}/local",

2.  put your hooks into that directory, in a sub-sub-directory called
    "hooks/common":

        # log on to gitolite hosting user on the server, then:
        cd $HOME
        mkdir -p local/hooks/common
        cp your-post-receive-hook local/hooks/common/post-receive
        chmod +x local/hooks/common/post-receive

3.  run `gitolite setup` to have the hooks propagate to existing repos (repos
    created after this will get them anyway).


-------------------------------------------------------------------------------



# gitolite hooks relate man

https://gitolite.com/gitolite/cookbook#hooks

https://gitolite.com/gitolite/cookbook#vrefs

https://gitolite.com/gitolite/rc.html

https://gitolite.com/gitolite/non-core#hooks-and-gitolite

https://gitolite.com/gitolite/non-core#core-versus-non-core

https://gitolite.com/gitolite/vref.html

https://gitolite.com/gitolite/vref-2.html

https://gitolite.com/gitolite/triggers.html

https://gitolite.com/gitolite/install#moving-servers

