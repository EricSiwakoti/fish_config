# CLI Friendly Web Services

# Displays the external IP address.
alias myip='curl ifconfig.co'

# Shows the local/internal IP address.
# Alternative: `ifdata -pa eth0` from moreutils.
alias localip="ip -o route get to 1.1.1.1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'"

# Provides external IP and geolocation information.
alias whereami='curl ifconfig.co/json'

# Fetches and displays weather data for a specified location.
function weather --description "Show weather information for a given location."
  curl wttr.in/$argv
end

# Finds synonyms for a given word.
function syn --description "Find synonyms for a word."
  test -e ~/git/stuff/keys/bighugelabs || echo "Get API key at https://words.bighugelabs.com/account/getkey and put it in (~/git/stuff/keys/bighugelabs)"
  curl http://words.bighugelabs.com/api/2/(cat ~/git/stuff/keys/bighugelabs)/$argv/
end

# Waits until a specified web resource becomes available.
function waitweb --description 'Wait until a web resource is available.' --argument-names 'url'
  set -q url || set url 'google.com'
  printf "Waiting for $url"

  while not curl --output /dev/null --silent --head --fail "$url"
    printf '.'
    sleep 10
  end

  printf "\n$url is online!"
  notify-send -u normal "$url is online!"
end

# Provides syntax explanations for commands using explainshell.com.
function xsh --description "Explain command syntax."
  w3m -o confirm_qq=false "http://explainshell.com/explain?cmd=$argv"
end
