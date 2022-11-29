if [ "$(getprop ro.product.brand)" != "realme" ]; then
  abort "Not a realme device"
fi

if [ $API -lt 29 ] || [ $API -gt 33 ]; then 
  abort "! Unsupported system API! $API"
fi
