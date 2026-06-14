function save_figure(figHandle, baseName, fmt)
% SAVE_FIGURE  Save a figure to figures/output as vector PDF (default) or,
% with fmt='image', a high-resolution PNG (preferred for dense 3-D plots).
% PDF export falls back to PNG when vector export is unavailable.

if nargin < 3 || isempty(fmt), fmt = 'vector'; end

here   = fileparts(mfilename('fullpath'));
outdir = fullfile(here, '..', 'figures', 'output');
if ~exist(outdir, 'dir'), mkdir(outdir); end

if strcmpi(fmt, 'image')
    pngPath = fullfile(outdir, [baseName '.png']);
    exportgraphics(figHandle, pngPath, 'Resolution', 300);
    fprintf('Saved figures/output/%s.png\n', baseName);
    return;
end

pdfPath = fullfile(outdir, [baseName '.pdf']);
try
    exportgraphics(figHandle, pdfPath, 'ContentType', 'vector');
    fprintf('Saved figures/output/%s.pdf\n', baseName);
catch
    pngPath = fullfile(outdir, [baseName '.png']);
    exportgraphics(figHandle, pngPath, 'Resolution', 200);
    fprintf('Saved figures/output/%s.png (vector export unavailable)\n', baseName);
end
end
