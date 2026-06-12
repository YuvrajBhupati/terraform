module trivy-license-test

go 1.25.6

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/spf13/cobra v1.8.1      
    github.com/open-policy-agent/opa v0.63.0
    github.com/gogo/protobuf v1.3.2
    
    github.com/ulikunitz/xz v0.5.11
    
    # Test vulnerability + different metadata
    github.com/dgrijalva/jwt-go v3.2.0+incompatible  // vulnerable ✅
)
