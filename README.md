# Proprietary-fonts

A private-use nix package for some proprietary fonts I own.

> [!NOTE]
> While this repository is public, the font files themselves are encrypted.
> This is because I do not have a licence to distribute the packaged fonts.
> To actually use the packages in this repository, you need the decryption
> key, which I legally cannot give you. You wouldn't download a car (and
> then publish it on your personal github account).
>
> You are welcome to fork this repository and package your _own_ font files
> encrypted with your own private key. 

## Usage

Acquire the encryption key (age identity file) used to encrypt the files
in this repository by e.g. being me and having access to the key. Please
do not attempt rubber-hose cryptanalysis – the fonts aren't worth it I hope.

Add the font package(s) you want to use to your system's `fonts.packages`
by adding an override with the correct `key` attribute:
```nix
# inputs.proprietary-fonts.url = "github:emsknock/proprietary-fonts";
{
    fonts.packages = let 
        key = "AGE-SECRET-KEY…";
        pkg = inputs.proprietary-fonts.packages."x86_64-linux".mono-lisa;
    in [
        (pkg.override { inherit key; })
    ];
}
```

### FAQ

<details>
<summary>Isn't it dangerous to have the key in your nix store?</summary>

Aye, it usually is. Here, however, the packages the key protects get written
to the system store anyhow. If you're already in my system, and can steal the
key, you can just steal the files instead. Please don't steal anything else
and get out of my system when you're done.

</details>

<details>
<summary>Isn't it kinda dumb to use a package override like this?</summary>

Could very well be. I do also use private repos for similar stuff, which is
probably the more "proper" way to do something like this. I'm mostly trying
this out with [`sops-nix`](https://github.com/mic92/sops-nix) to see if the
UX is nicer than having private repos as flake inputs.

</details>

<details>
<summary>Can you send me the unencrypted font files, please?</summary>

Not today, NCA. Try [pirating some other fonts instead](https://hackaday.com/2025/04/25/you-wouldnt-steal-a-font/).

</details>

## Adding fonts

To add a font named `foobar`, create a directory `data/foobar/` and move your
`.ttf` files there. Then run `just add-font foobar` and add `"foobar"` to the
`font` list in [`flake.nix`](./flake.nix).

## TODO

- Key rotation
- Non-ttf font support
- Hoard more nice fonts

