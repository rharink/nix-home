function vault_ssh_sign --description "vault_ssh_sign <public_key> [options -ehr]"
    set -l public_key
    set -l engine "ssh-client-signer"
    set -l role "default"

    getopts $argv | while read -l key value
        switch $key
            case _
              while read -l target
                set public_key $target
              end < $value
            case r role
                set role $value
            case e engine
                set engine $value
            case h help
                _vault_ssh_sign_help >&2
                return
        end
    end

    if test -n "$public_key"
      vault write -field=signed_key $engine/sign/$role public_key=$public_key;
      return
    end

    _vault_ssh_sign_help
end

function _vault_ssh_sign_help
  echo ""
  echo "vault_ssh_sign <public_key> [options -ehor]"
  echo ""
  echo "  -e=<engine>  vault secret engine path (ssh-client-signer)"
  echo "  -h           this help"
  echo "  -r=<role>    vault role (default)"
  echo ""
  echo "  EXAMPLE:"
  echo "    vault_ssh_sign ~/.ssh/id_rsa.pub > id_rsa-cert.pub"
  echo ""
end
