

const gfzrnx = string(@__DIR__,"/","gfzrnx", 
                    isapple ? "_osx" : 
                        islinux ? "_lx" :
                            throw("no gfz win yet") )

