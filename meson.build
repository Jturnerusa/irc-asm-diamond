project('irc-diamond', 'nasm', 'c')

diamond = library('diamond', 'diamond.asm')

irc_diamond = executable('irc-diamond', 'main.asm', dependencies: [diamond])

irc_diamond_test = test('irc-diamond-test',
                        executable('irc-diamond-tests',
                                   'test.c',
                                   dependencies: [diamond])
                       )
