

const rinex3_lht = string(bin_dir, "/", "rinex3_lht" ,
                            isapple ? "_macox" :
                                islinux ? "_linux" :
                                    throw("no rinex3_lht in windows yet"),
                    )
