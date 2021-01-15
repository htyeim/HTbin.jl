

const RNXCMPVER = isapple ? "RNXCMP_4.0.8_MacOSX10.14_gcc" :
                        islinux ? "RNXCMP_4.0.8_Linux_x86_64bit" :
                                throw("no windows!")

const CRX2RNX    = string(@__DIR__, "/", RNXCMPVER, "/bin/CRX2RNX")
const RNX2CRX    = islinux ? 
                        string(@__DIR__,
                                "/","RNXCMP_4.0.8_Linux_x86_32bit",
                                "/bin/CRX2RNX") :
                        string(RNXCMPVER, "/RNX2CRX")
