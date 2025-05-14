


if [ $
    echo "Usage: $0 <terraform-directory>"
    echo "Example: $0 ../02-eks-vanilla"
    exit 1
fi

TERRAFORM_DIR="$1"


if [ ! -f "${TERRAFORM_DIR}/variables.tf" ]; then
    echo "Error: variables.tf not found in ${TERRAFORM_DIR}"
    exit 1
fi


is_list_type() {
    local file=$1
    local var_name=$2
    grep -A2 "variable \"$var_name\"" "$file" | grep "type.*=.*list" > /dev/null
}


echo -n > "${TERRAFORM_DIR}/data.tf"


grep -n "variable \"ssm_" "${TERRAFORM_DIR}/variables.tf" | while read -r line; do
    
    var_name=$(echo "$line" | sed 's/.*variable "\([^"]*\)".*/\1/')
    
    
    if is_list_type "${TERRAFORM_DIR}/variables.tf" "$var_name"; then
        
        cat >> "${TERRAFORM_DIR}/data.tf" << EOF
data "aws_ssm_parameter" "${var_name
  count = length(var.${var_name})
  name  = var.${var_name}[count.index]
}

EOF
    else
        
        cat >> "${TERRAFORM_DIR}/data.tf" << EOF
data "aws_ssm_parameter" "${var_name
  name = var.${var_name}
}

EOF
    fi
done

echo "data.tf has been generated in ${TERRAFORM_DIR}" 