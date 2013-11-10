--  revision.lua -- Monotone extension command "mtn revision"
--  usage: mtn --rcfile revision.lua revision

register_command(
    "revision", "",
    "Print info about actual revision.",
    "Determines the base revision and whether the current " ..
    "revision is different. Prints the information " ..
    "suitable for inclusion into restructured text.",
    "command_revision"
)   

preamble_text = [=[

### Revision

Die Markdown-Quellen dieses Buches werden im verteilten
Revisionsverwaltungssystem *monotone* gespeichert.
]=]

function say(abc) io.stdout:write(abc .. "\n") end

function certdate(certtext)
    local date = string.match(certtext,'name "date"%s+value "[^"]+"')
    date = string.match(date,"[0-9-]+")
    return date
end

function command_revision()
    rc, txt = mtn_automate("get_base_revision_id")
    base_rev = string.match(txt,"%x+")
    if nil == base_rev then
        base_rev = ""
    end
    input, output, pid = spawn_pipe("mtn", "ls", "changed")
    res, rc = wait(pid)
    changed = output:read('*a')
    rc, txt = mtn_automate("certs",base_rev)
    base_date = certdate(txt)

    say(preamble_text)
    say("Diese Ausgabe basiert auf Revision " .. base_rev)
    say("von " .. base_date .. ".")
    if 0 < string.len(changed) or "" == base_rev then
        rc, txt = mtn_automate("get_current_revision_id")
        curr_rev = string.match(txt,"%x+")
	say("")
        say("In diesem Buch sind Änderungen bis " .. os.date('%Y-%m-%d'))
	say("enthalten, die temporäre Revision ist " .. curr_rev .. ".")
    end
end
