
function Cipher-EncodeCaesar {
    <#
        .synopsis
            more of a wierd array operator example


        .notes
            # kind of, not really.  https://en.wikipedia.org/wiki/Caesar_cipher

        range: [0,25]

        #>
    throw 'NYI'
    'test case
        Plain,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
        Cipher,X,Y,Z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W

        Plaintext:  THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG
        Ciphertext: QEB NRFZH YOLTK CLU GRJMP LSBO QEB IXWV ALD
'
    'e_n (x) = (x + n) % 26'
    'd_n (x) = (x - n) % 26
        '
}
