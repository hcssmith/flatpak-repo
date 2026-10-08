#!/bin/sh
# Build and install the flatpak.
#
# --disable-rofiles-fuse: rofiles-fuse wedges at its unmount/remount
# boundary on this machine (kernel 7.2 / fuse3), leaving zombie mounts that
# fail builds with "Failure spawning rofiles-fuse, exit_status: 1024" even
# when the build itself succeeded. flatpak-builder then falls back to
# private source copies; build results are identical.
#
# The fusermount3 loop clears any zombie mounts left by earlier runs.
set -e
cd "$(dirname "$0")"

for m in $(mount | grep -oP "$PWD/\.flatpak-builder/rofiles/rofiles-\S+" || true); do
  fusermount3 -uz "$m"
done
rm -rf .flatpak-builder/rofiles

# Vendored cargo sources live in bin/ripgrep/generated-sources.yml and are
# regenerated on demand with bin/ripgrep/update-sources when the pinned
# ripgrep tag changes; keeping this out of the build keeps builds
# reproducible and the tree clean.

flatpak run org.flatpak.Builder  --user --install-deps-from=flathub --install --force-clean --disable-rofiles-fuse build com.hcssmith.Nvim.yml "$@"
flatpak run org.flatpak.Builder  --user --install-deps-from=flathub --install --force-clean --disable-rofiles-fuse build com.hcssmith.Neovide.yml "$@"

