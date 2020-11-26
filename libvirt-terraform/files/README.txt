Base64 encode files with: bash -c 'cat <input file> | base64 | awk '{print}' ORS='' && echo'  >    <output file>.b64

-or-

Use the script: ./encoder.sh <input file>

Add encoded file to node's cloud init file:
  - path: <absolute pathname of file on the target node>
    encoding: b64
    permissions: "0644"
    content: 
