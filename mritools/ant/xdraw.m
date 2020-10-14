

% #ok xdraw (xdraw.m)
% Manually draw mask. 
% This mask can contain several ROIs/masks with different numeric values (IDs).
% Input: a background file and optional a mask file (or unfinished mask).
% #r: at the current development stage don't use an atlas-file with to many ROI-IDs
% #b for more information see coltrol's tooltips
% ________________________________________________________________________________
% #ka *** Draw MASK ***
% --> deselect [unpaint]-button (gray color)
% * Keep the left mouse-button pressed to draw .. colorize pixels below pointer.
% * Double-click to fill a region (boundaries of region must be closed)
% * Single click right mouse button to remove region below pointer 
% #ka *** REMOVE MASK ***
% --> select [unpaint]-button (orange color)
% * Keep the left mouse-button pressed to unpaint .. remove colorized pixels below pointer.
% * Single click right mouse button to remove region below pointer 
% * [c] shortcut to clear slice or use clear-pulldown menu
% ________________________________________________________________________________
% #ka *** UI CONTROLS ***
% 
% #kl *** CONTROL ROW-1 *** 
% #m [control] [shortcut]  ..explanation
% #b [otsu][o]        #n  make otsu-clustered image. This will open another figure)
%                     #r see below for more details  
% #b [unpaint][u]     #n  remove drawn location, toggle between drawing and unpainting mode
%                       -If 'on': the 'unpainting' mode erases all IDs in voxels below the moved 
%                        brush-pointer when left mouse button is down.
%                       -If 'off': the 'drawing' mode is enabled and voxels below the moved 
%                        brush-pointer obtain the current ID when left mouse button is down 
% #b [undo][ctr+x]    #n  undo last step(s)
%                     -go back to previous steps as long as the slice-number/dimension is not changed.
% #b [redo][ctr+y]    #n  redo last step(s)
%                     -..as long as the slice-number/dimension is not changed.
% #b [show legend][l] #n  show/hide legend with drawn IDs 
%                       -shows for each drawn ID the respective color, number of voxels and volume 
% #b [i] [i]          #n  show information: 
%                                   File-information, 
%                                   drawn IDs (+color, number of voxels and volume)
%                                   slice-wise information  
% #b [m] [m]          #n show montage of slices.
%                     -show semi-transparent overlay of bg-image and (multi-ID) mask for all slices
% 
% #kl *** CONTROL ROW-2 *** 
% #b [brush type] [b]              #n change brush type, {dot,square, vertical/horizontal line}
% #b [brush size] [up/down arrow]  #n change brush size
% #b [dim] [d]                     #n change viewing dimension {1,2,3}
% #b [left arrow] [left arrow]     #n show previous slice
% #b [slice number]                #n edit and show this slice number
% #b [right arrow][right arrow]    #n show next slice
%
% #b [transpose]  #n transpose (rotate 90ｰ) current slice 
% #b [flipud]     #n flip upside-down current slice 
% 
% #b [transparency]  #n set transparency  of the mask range 0-1
% #b [hide mask] [h] #n shortly hide mask
%                    -alternatively, use [space] shortcut to toggle between bg-image and mask 
% 
% #kl *** Right-side CONTROLS *** 
% #b [sat CON][s]    #n saturate/adjust contrast; If enabled, use default contrast enhancement
%                     'auto' from the right pulldown-menu
%                     -change contrast values in right pull-down menu ('auto')
% #b [auto]          #n puldown with min/max values for low and high cotrast enhancing values
%                    -changes apply only if [sat CON] is enabled
%                    -you can also edit two values (min max value in range between 0 and 1)
% #b [clear]         #n clear mask of current slice/clear entire 3d mask
%                    #r shortcut [c] clears the mask of the current image
% #r [special drawing tools]
% #b [freehand]  [1] #n freehand drawing
% #b [rectangle] [2] #n draw rectangle
% #b [ellipse]   [3] #n draw ellipse/circle
% #b [polygon]   [4] #n draw polygon
% #b [line]      [5] #n draw line
% #g After selecting a drawing tool (for instance 'freehand') you can draw on the image as long
% #g as the left mouse button is pressed. After button release the user decides (via icons)
% #g what to do with the drawn region: fill region, use regions border only, remove IDs below  
% #g region or dismiss region. 
% #g Note that the filling and region border options put the current ID in the respective voxels 
% #g The drawing icon is deselected afterwards! 
% #g Use shortcut to re-evoke action.
% 
% #r [ID] region value #n Region value. This numeric region value is used for drawing. 
%              -edit another numeric value (2,3,4..etc). Tha this value will be used in the 
%               next drawing operation
%              -default drawing ID: 1
% #g To recap, first set the ID, than draw something.
% #r [ID list]   #n list of all IDs (numeric values) found in the 3D-mask
%                -select one of the IDs in the list to use selected ID as current ID
%
% #b [measure distance]  #n This tool allows to measure a distance (mm & pixels) and angle between
%                        two points (squares). Move the two squares to the respective position.
% #b [WinFocu][a]  #n If 'on' the window below mouse pointer (hover effect) becomes focused/active.
%               -This option is usefull for otsu-segmentation (two windows are open). By default ('off'),
%                one has to select the other non-active window to use it's functions. Using the auto-
%                focus, we can avoid the extra selection step. 
% #g Example: transmit a region from otsu-segmentation window to main window (left click) 
% #g and fill it in the main window just by hoving the mouse over the main window and left 
% #g double-click to fill the region.
% 
% #b [config]    #n change configuration
%                   -change some of the paramters 
%                   * auto-focus windo below mouse (might be of help for otsu-operations)
%                   * show/hide toolbar
% #b [help]    #n open help window
%
% #b [saving options] #n select the type of image to saved (mask, masked image)
%                   * mask only
%                   * different types of masking the background image. See pull-down menu. 
% #b [save]  #n save the image ...saving mode depends on [saving options]
%
% #kl *** OTSU Segmentation *** 
% Clicking the otsu button opens a new window with otsu segmentation of the current slice
% Here, you can change the median-filter length (default: 3) to 'smooth' the intensities and
% change then number of otsu classes. Both paramter have imidiate effect on the otsu image.
% #b [classes]  #n number of otsu-classes/clusters, {2...n}
%        #b [arrow up/down] shortcuts to decrease/increase the number of otsu-classes
% #b [medfilt]  #n filter length of the 2d median filter, {1...n} 
%        #b [ctrl+arrow up/down] shortcuts to decrease/increase filter length (smoothness)
% #b [cut cluser][x]  if enabled, Draw a line through cluster to separate cluster 
%                     -[cut cluser] can be used to parcelate a cluster. A cutted part of a cluster
%                      can than transmitted to the main window
%                     use shortcut [x] to toggle enable/disable [cut cluser] function
% #r LEFT MOUSE-BUTON #n   click onto a region to transmit this region to the main window.
%                           The transmitted region obtains the ID (value) of the current selected
%                           ID.
% #g The otsu-window preserves some of the keyboard shortcuts from the main window. 
% #g Thus, it's possible to keep the otsu-winow focused and 'scroll' through the slices
% #g (left/right arrow keys), transmit a selected otsu region (left mouse button),
% #g change the otsu-classes (up/down arrows) and median filter (ctrl+up/down arrows),
% #g undo/redo steps (ctrl+x/y) or clear the slice (c).
% #g Try the window auto-focus mode (enabled via configuration settings)
% ====================================================================================
% #kl COMMANDLINE
% xdraw(fullfile(pwd,'AVGT.nii'),[]);  % #g load bg-image, load no mask
% xdraw(fullfile(pwd,'AVGT.nii'),fullfile(pwd,'AVGThemi.nii'));  % #g load bg-image, load existing mask
% xdraw(fullfile(pwd,'t2.nii'),fullfile(pwd,'masklesion.nii'));
% 
% 


function  xdraw(file,maskfile)
try; delete(findobj(0,'tag','otsu'));end
clear global SLICE
% ==============================================
%%   file
% ===============================================
if exist('file')~=1
    msg='select background file (NIFTI) ...mandatory';
    disp(msg);
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),msg);
    if isnumeric(fi);
        return;
    end
    file=fullfile(pa,fi);
end
u.f1=file;
[ha a]=rgetnii(u.f1);

% ==============================================
%%   maskfile
% ===============================================
if exist('maskfile')~=1
    msg='select mask file (NIFTI) or hit "cancel" ...optional';
    disp(msg);
    disp('The mask file be in register with the background image (similar w.r.t voxel-size,dims,orientation)');
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),msg);
    if isnumeric(fi)
        maskfile=[];
    else
        maskfile=fullfile(pa,fi);
    end
end
maskmode=1;
if isempty(maskfile)
    u.f2=[];
    hb=ha;
    b=zeros(size(a));
    
else
    
    u.f2=maskfile;
    [hb b]=rgetnii(u.f2);
    nvalues=length(unique(b));
    
    if nvalues>100
        % ==============================================
        %%   input-dlg
        % ===============================================
        filestr=regexprep(u.f2,{['\' filesep] ,'_'},{['\' filesep filesep] '\\_' });
        prompt = {
            ['\color{blue} FILE: \color{black} \bf ' '"' filestr '"'  '\rm' char(10) ...
            'The selected mask contain \color{magenta}' num2str(nvalues) '\color{black} different values.' char(10) ...
            'This seems to be a lot for a mask. ' char 10 ...
            char(10) ...
            '\bf HOW TO PROCEED?'  '\rm' char(10)  ...
            '  [1] Proceed and try it ' char(10) ...
            '  [2] Reduce  number of values in mask volume ' char(10) ...
            '  [3] Proceed without using the selected mask'  char(10) ...
            ],'\bf For [2] only: Enter number of values to use for the mask (Otsu-approach).'};
        dlg_title = ['MASKfile: issue' repmat(' ',[1 150])];
        num_lines = 1;
        defaultans = {'1','32'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans,struct('Interpreter','tex'));
        
        %% procees
        if isempty(answer); return; end
        maskmode=str2num(answer{1});
        if maskmode==2
            nclassesOtsu=str2num(answer{2});
            b= reshape(otsu(b(:),nclassesOtsu), hb.dim);
        elseif maskmode==3
            u.f2=[];
            hb=ha;
            b=zeros(size(a));
        end
        
        
        % ==============================================
        %%   end
        % ===============================================
        % ok, try it
        
        % otsu-reduce intensity values
        
        % no, abort mask
        
        
    end
    
    if maskmode==1
        [h,d ]=rreslice2target(u.f2, u.f1, [], 0);
        hb=h;
        b =d;
        
        uni=unique(b);
        if median(double(round(uni*10)/10==uni ))==0
            b=double(b>0);
        end
    end
    
end

% ==============================================
%%  parameter-1
% ===============================================
pp.autofocus                =   0  ;
pp.toolbar                  =   0  ;
pp.otsu_numClasses          =   3  ;
pp.otsu_medianFltLength     =   3  ;
pp.numColors                =   15 ;

u.config={
    'autofocus'         pp.autofocus           'autofocus figure under mouse{0,1}...no/yes' 'b'
    'toolbar'           pp.toolbar             'show toolbar {0,1}...no/yes' 'b'
    'inf1'             [' OTSU ' repmat('=',[1 20])  ]               '' ''
    'otsu_numClasses'        pp.otsu_numClasses          'number of otsu classes'   ''
    'otsu_medianFltLength'   pp.otsu_medianFltLength     'length of otsu median-filter'   ''
    'inf2'  '' '' ''
    'inf3'             [' Mich. ' repmat('=',[1 20])  ]               '' ''
    'numColors'          pp.numColors          'number of used colors '   ''
    };
u.set=pp;
%===================================================================================================

%% FIGURE...params-2
%===================================================================================================

delete(findobj(0,'tag','xpainter'));
fg;
set(gcf,'units','norm','menubar','none','name','xdraw','NumberTitle','off','tag','xpainter');
makegui;
u.dummy=1;
set(gcf,'userdata',u);

% return
% return
u.him=[];
u.usedim =3;
% u.pensi  =10;
u.alpha  =.4;
u.dotsize=5;
u.dotsizes=([1:200]);
u.a=a; u.ha=ha;
u.b=b; u.hb=hb;
u.dim=u.ha.dim;
u.useslice=round(u.dim(u.usedim)/2);
set(gcf,'userdata',u);

def_colors();
set(findobj(gcf,'tag','dotsize'),'string',num2cell(u.dotsizes),'value',u.dotsize);
setslice();
set(gcf,'WindowButtonMotionFcn', {@motion,1})
set(gcf,'WindowButtonDownFcn', {@buttondown,[]});
set(gcf,'WindowButtonUpFcn'     ,@selstop);
set(gcf,'WindowKeyPressFcn',@keys);
set(gcf,'SizeChangedFcn', @resizefig);
set_idlist;
edvalue([],[]);

% ==============================================
%%   timer
% ===============================================
timercheck();
% ==============================================
%%   END
% ===============================================

% %===================================================================================================
% function resizefig(e,e2)
% return
% % 
% % hf1=findobj(0,'tag','xpainter');
% % u=get(hf1,'userdata');
% % if isfield(u,'controls')==0
% %     u.controls=findobj(gcf,'Type','uicontrol');
% %     set(u.controls,'units','pixels');
% %     u.controls_pospix=get(u.controls,'position');
% %     set(u.controls,'units','norm');
% %     u.controls_posnorm=get(u.controls,'position');
% %     set(hf1,'userdata',u);
% % end
% % 
% % set(u.controls,'units','pixels');
% % for i=1:length(u.controls)
% %     pos=get(u.controls(i),'position');
% %     pos(3:4)=u.controls_pospix{i}(3:4);
% %     set(u.controls(i),'position',pos);
% % end
% % set(u.controls,'units','norm');


function def_colors()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
colmat = distinguishable_colors(u.set.numColors,[1 1 1; 0 0 0]);
% colmat=[colmat([2 1 13:end],:)];
% figure; image(reshape(c,[1 size(colmat)]));
u.colmat=colmat;
set(hf1,'userdata',u);

function timercheck()
hf1=findobj(0,'tag','xpainter');
us=get(gcf,'userdata');
if us.set.autofocus==1
    set(findobj(hf1,'tag','rd_autofocus'),'value',1, 'backgroundcolor',[1 0.8431 0]);
    timerstart;
else
    delete(timerfindall);
    set(findobj(hf1,'tag','rd_autofocus'),'value',0, 'backgroundcolor','w');
end

% ==============================================
%%   timer for focus
% ===============================================
function timerstart
delete(timerfindall);
t = timer('ExecutionMode', 'FixedRate', ...
    'Period', .5, ...
    'TimerFcn', {@timerCallback});
start(t)
set(gcf, 'CloseRequestFcn', 'disp(''closing figure...''); delete(timerfindall);closereq');

function timerCallback(e,e2)
fig = matlab.ui.internal.getPointerWindow();
%     disp(fig);
if fig==0; return; end
figure(fig);


function cb_configuration(e,e2)
delete(timerfindall);
configuration();
drawnow;
timercheck();


function configuration
u=get(gcf,'userdata');
x=u.set;
p=u.config;
p=paramadd(p,x);%add/replace parameter
% hlp=help(); hlp=strsplit2(hlp,char(10))';
[m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.1500    0.4011    0.3625    0.2000 ],...
    'title','***config***','info',{'--'});
if isempty(m); return; end
fn=fieldnames(z);
z=rmfield(z,fn(regexpi2(fn,'^inf\d')));

u.set=z;
set(gcf,'userdata',u);
hf1=findobj(0,'tag','xpainter');
if z.toolbar==1;                  %menubar
    set(hf1,'toolbar','figure');
else
    set(hf1,'toolbar','none'); 
end

if  u.set.numColors~=x.numColors   %COLORS
    def_colors();
    setslice();
    set_idlist;
    edvalue([],[]);
end
% ==============================================
%% callback autofocus
% ===============================================
function rd_autofocus(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
u.set.autofocus=get(findobj(hf1,'tag','rd_autofocus'),'value');
set(gcf,'userdata',u);

timercheck();


% ==============================================
%% otsu key
% ===============================================
function keys_otsu(e,e2)
hf2=findobj(0,'tag','otsu');
hf1=findobj(0,'tag','xpainter');

if isempty(e2.Modifier)==1
    if strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
        hb=findobj(hf2,'tag','ed_otsu');
        nclasses=str2num(get(hb,'string'));
        if strcmp(e2.Key,'uparrow');
            nclasses=nclasses-1;
            if nclasses<2;              nclasses=2  ;      end
        else
            nclasses=nclasses+1;
        end
        set(hb,'string',num2str(nclasses));
        hgfeval(get(hb,'callback'),[],1);
    elseif strcmp(e2.Key,'leftarrow') || strcmp(e2.Key,'rightarrow')
        if strcmp(e2.Key,'leftarrow');
            hb=findobj(hf1,'tag','prev');
            figure(hf1);
            hgfeval(get(hb,'callback'),[],-1);
            figure(hf2);
        else
            hb=findobj(hf1,'tag','next');
            figure(hf1);
            hgfeval(get(hb,'callback'),[],+1);
            figure(hf2);
        end
    elseif strcmp(e2.Key,'s');        %saturate contrast
        hf1=findobj(0,'tag','xpainter');
        hb=findobj(hf1,'tag','cb_adjustIntensity');
        set(hb,'value', ~get(hb,'value') );
        cb_adjustIntensity([],[]);
    %hgfeval(get( hb ,'callback'),[], 1);   
    elseif strcmp(e2.Key,'h')
        figure(hf1);
        cb_preview();
        figure(hf2);
    elseif strcmp(e2.Key,'space')
        figure(hf1);
        u=get(gcf,'userdata');
        if isfield(u,'ispreview')==0
            u.ispreview=0;
        end
        u.ispreview=~u.ispreview;
        set(gcf,'userdata',u);
        if u.ispreview==1
            setslice(1);
        else
            setslice();
        end
        figure(hf2);
    elseif strcmp(e2.Key,'c')    %clear slice
        figure(hf1);
        hf1=findobj(0,'tag','xpainter');
        hb=findobj(hf1,'tag','clear mask');
        set(hb,'value',1);
        hgfeval(get(hb,'callback'),[],[])
        figure(hf2);
    elseif strcmp(e2.Key,'u'); % unpaint
        figure(hf1);
        o=findobj(gcf,'tag','undo');
        if get(o,'value')==0; set(o,'value',1); else; set(o,'value',0); end
        undo();
        figure(hf2);
        % elseif strcmp(e2.Key,'t'); % zoom
        %        'a'
    elseif strcmp(e2.Key,'x'); % cut cluster
          hb= findobj(hf2,'tag','pb_otsucut');
          set(hb,'value',~get(hb,'value'));
         hgfeval(get( hb ,'callback'));
    end
end

figure(hf1);
if strcmp(e2.Modifier,'control')
    if strcmp(e2.Key,'z')
        pb_undoredo([],[],-1);
    elseif strcmp(e2.Key,'y')
        pb_undoredo([],[],+1);
    end
    
    if strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
        hb=findobj(hf2,'tag','otsu_medfilt_val');
        medfiltlength=str2num(get(hb,'string'));
        if strcmp(e2.Key,'uparrow');
            medfiltlength=medfiltlength-1;
            if medfiltlength<1;              medfiltlength=1  ;      end
        else
            medfiltlength=medfiltlength+1;
        end
        set(hb,'string',num2str(medfiltlength));
        hgfeval(get(hb,'callback'),[],1);
    end
end
figure(hf2);

% ==============================================
%% main fig key
% ===============================================
function keys(e,e2)
try
    if strcmp(get(gco,'style'),'edit')
        return
    end
end

if strcmp(e2.Key,'leftarrow')
    cb_setslice([],[],'-1');
elseif strcmp(e2.Key,'rightarrow')
    cb_setslice([],[],'+1');
elseif strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
    o=findobj(gcf,'tag','dotsize');
    li=get(o,'string');
    va=get(o,'value');
    %oldsize=str2num(li{va});
    if strcmp(e2.Key,'uparrow')
        va=va-1;
    elseif strcmp(e2.Key,'downarrow')
        va=va+1;
    end
    if     va>length(li);     va=length(li);
    elseif va<1;              va=1;
    end
    set(o,'value',va);
    definedot([],[]);
elseif strcmp(e2.Key,'f');
    cb_fill();
elseif strcmp(e2.Key,'s');        %saturate contrast
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','cb_adjustIntensity');
    set(hb,'value', ~get(hb,'value') );
    cb_adjustIntensity([],[]);
    %hgfeval(get( hb ,'callback'),[], 1);
     
elseif strcmp(e2.Key,'t'); % zoom
       hf1=findobj(0,'tag','xpainter');
       u=get(hf1,'userdata');
       if u.set.toolbar==1
          u.set.toolbar=0; 
          set(gcf,'toolbar','none');
       else
          u.set.toolbar=1; 
          set(gcf,'toolbar','figure');
       end
       set(hf1,'userdata',u);
elseif  strcmp(e2.Key,'a');              % AUTOFOCUS
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','rd_autofocus');
    set(hb,'value' , ~get(hb,'value') );
    rd_autofocus([],[]);
elseif strcmp(e2.Key,'l');
    o=findobj(gcf,'tag','pb_legend');
    set(o,'value',~get(o,'value'));
    pb_legend([],[]);
elseif strcmp(e2.Key,'i');
    pb_slicewiseInfo([],[]);
    
elseif strcmp(e2.Key,'d') ;%strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
    e=findobj(gcf,'tag','rd_changedim');
    li=get(e,'string'); va=get(e,'value');
    olddim=str2num(li{va});
    %     if strcmp(e2.Key,'uparrow')
    newdim=olddim+1;
    %     else
    %         newdim=olddim-1;
    %     end
    if newdim>3;     newdim=1;
    elseif newdim<1; newdim=3;end
    set(e,'value',newdim);
    pop_changedim();
    % elseif regexpi(e2.Key,['^\d$'])
    %    o=findobj(gcf,'tag','edvalue');
    %    set(o,'string',e2.Key);
elseif strcmp(e2.Key,'u')
    o=findobj(gcf,'tag','undo');
    if get(o,'value')==0; set(o,'value',1); else; set(o,'value',0); end
    undo();
elseif strcmp(e2.Key,'h')
    cb_preview();
elseif strcmp(e2.Key,'space')
    u=get(gcf,'userdata');
    if isfield(u,'ispreview')==0
        u.ispreview=0;
    end
    u.ispreview=~u.ispreview;
    set(gcf,'userdata',u);
    hf1=findobj(0,'tag','xpainter');
    if u.ispreview==1
        setslice(1); %hide mask
        set(findobj(hf1,'tag','preview'),'backgroundcolor',[ 1.0000    0.8431         0]);
    else
        setslice(); %show mask
        set(findobj(hf1,'tag','preview'),'backgroundcolor',[repmat(.94,[1 3])]);
    end
    return
    
    
elseif strcmp(e2.Key,'b')
    e=findobj(gcf,'tag','rd_dottype');
    li=get(e,'string'); va=get(e,'value');
    va=va+1;
    if va>4; va=1; end
    set(e,'value',va);
    definedot([],[]);
    % elseif strcmp(e2.Key,'c')
    %     hf1=findobj(0,'tag','xpainter');
    %     hf2=findobj(0,'tag','otsu');
    %     if isempty(hf2); return; end
    %     figure(hf2);
    %     pb_otsouse(e,e2)
    %     figure(hf1);
elseif strcmp(e2.Key,'c')    %clear slice
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','clear mask');
    set(hb,'value',1);
    hgfeval(get(hb,'callback'),[],[]);
elseif strcmp(e2.Key,'o')
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','pb_otsu');
    set(hb,'value',~get(hb,'value') );
    pb_otsu([],[],1);
    % elseif strcmp(e2.Character,'+')
    %     hf1=findobj(0,'tag','xpainter');
    %     hf2=findobj(0,'tag','otsu');
    %     he=findobj(hf2,'tag','ed_otsu');
    %     str=num2str(str2num((get(he,'string')))+1);
    %     set(he,'string',str);
    %     hgfeval(get(he,'callback'),he);
    %     figure(hf1);
    % elseif strcmp(e2.Character,'-')
    %      hf1=findobj(0,'tag','xpainter');
    %     hf2=findobj(0,'tag','otsu');
    %     he=findobj(hf2,'tag','ed_otsu');
    %     str=str2num((get(he,'string')))-1;
    %     if str<2; return; end
    %
    %     set(he,'string',num2str(str));
    %     hgfeval(get(he,'callback'),he);
    %     figure(hf1);
% elseif strcmp(e2.Key,'z'); % zoom
%     z=zoom;
%     if strcmp( get(z,'enable'),'on')
%         %             set(z,'enable','off');
%         zoom off
%         'zoom off'
%     else
%         set(z,'enable','on');
%         'zoom on'
%         
%         
%     end
 elseif strcmp(e2.Key,'1') || strcmp(e2.Key,'2') || strcmp(e2.Key,'3')|| strcmp(e2.Key,'4')||  strcmp(e2.Key,'5')   
    num=str2num(e2.Key);
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'userdata','imtoolsbutton');
    hc=hb(end-num+1);
    type=getappdata(hc,'toolnr');
    set(hc,'value', ~get(hc,'value') );
    imdrawtool_prep(hc,[],type);
    uicontrol(findobj(hf1,'tag','undo'));
end


if strcmp(e2.Modifier,'control')
    if strcmp(e2.Key,'z')
        pb_undoredo([],[],-1);
    elseif strcmp(e2.Key,'y')
        pb_undoredo([],[],+1);
    end
    
end

%  e2
% ''

function v2=getslice2d(v3)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
if u.usedim==1
    v2=squeeze(v3(u.useslice,:,:));
elseif u.usedim==2
    v2=squeeze(v3(:,u.useslice,:));
elseif u.usedim==3
    v2=squeeze(v3(:,:,u.useslice));
end

% r1=imadjust(r1); 
% disp('adjustIM');


function cb_preview(e,e2)
hf1=findobj(0,'tag','xpainter');

setslice(1);
set(findobj(hf1,'tag','preview'),'backgroundcolor',[ 1.0000    0.8431         0]);
drawnow;
pause(.2);
setslice();
set(findobj(hf1,'tag','preview'),'backgroundcolor',[repmat(.94,[1 3])]);

function pb_otsu(e,e2,par)

hf1=findobj(0,'tag','xpainter');
figure(hf1);

hb=findobj(hf1,'tag','pb_otsu'); %otsu-button
if get(hb,'value')==0;
    delete(findobj(0,'tag','otsu'));
    return
end



hf2=findobj(0,'tag','otsu');
u=get(hf1,'userdata');




try
    u.set.otsu_numClasses=str2num(get(findobj(hf2,'tag','ed_otsu'),'string'));
% catch
%     u.set.otsu_numClasses=3;
end

try
    u.set.otsu_medianFltLength=str2num(get(findobj(hf2,'tag','otsuMedfilt'),'string'));
% catch
%     u.otsuMedfilt=3;
end
set(hf1,'userdata',u);


r1=getslice2d(u.a);
r1=adjustIntensity(r1);
r2=getslice2d(u.b);

if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end
% ----------------------------------------------------
hf2=findobj(0,'tag','otsu');
if isempty(hf2)
    %     'ri'
    fg;
    set(gcf,'units','norm','menubar','none','name','otsu','NumberTitle','off','tag','otsu');
    pos1=get(hf1,'position');
    pos2=pos1;
    pos2(1)=(pos2(1)-pos2(3)/2)-.016; pos2(3)=pos2(2)/2;
    set(gcf,'position',pos2);
    hf2=gcf;
    %     pointer=nan(16,16); pointer(:,8)=1; pointer(8,:)=1;
    %     drawnow
    %     set(gcf,'Pointer','custom');drawnow
    %     pointer=ones(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
    %     set(gcf,'PointerShapeCData',pointer);drawnow
    %     pointer=nan(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
    %     set(gcf,'PointerShapeCData',pointer);drawnow
    
    hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_otsouse');
    set(hb,'position',[ .1 .9 .5 .05],'string','select class for all slices', 'callback',{@pb_otsouse,3});
    set(hb,'fontsize',7,'backgroundcolor','w');
    set(hb,'tooltipstring',['select class for all slices' char(10) ' ']);
    
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'pb_otsucut');
    set(hb,'position',[ .7 .9 .2 .05],'string','cut cluster', 'callback',{@pb_otsucut,1});
    set(hb,'fontsize',7,'backgroundcolor','w','value',0);
    set(hb,'tooltipstring',['cut cluster' char(10) 'shortcut [o] ']);
    
    % ========classes=======================================================
    %otsu -number of classes-label
    hb=uicontrol('style','text','units','norm', 'string' ,'classes');
    set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
    set(hb,'position',[0 .95 .15 .04]);
    set(hb,'tooltipstring',['otsu define number of classes/clusters' char(10) '[arrow up/down]']);

    
    %otsu -number of classes
    hb=uicontrol('style','edit','units','norm', 'tag'  ,'ed_otsu','value',0);
    set(hb,'position',[ .15 .95 .1 .04],'string',num2str(u.set.otsu_numClasses), 'callback',{@pb_otsu,1});
    set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
    set(hb,'tooltipstring',['otsu define number of classes/clusters' char(10) '[arrow up/down]']);
    
    % =========median-filter======================================================
    
    %medianfilter-radio
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu_medfilt_rd','value',1);
    set(hb,'position',[ .3 .95 .18 .04],'string','medfilt', 'callback',{@pb_otsu,1});
    set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
    set(hb,'tooltipstring',['median filter image prior otsu-ing' char(10) '-']);
    
    
    %medianfilter-filtervalue
    hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu_medfilt_val');
    set(hb,'position',[ .48 .95 .08 .04],'string',num2str(u.set.otsu_medianFltLength), 'callback',{@pb_otsu,1});
    set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
    set(hb,'tooltipstring',['median filter length' char(10) '-']);
    
    % ========= OTSU-3d-panel-pushbutton======================================================
  
%      hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_otsu3Dmontage');
%     set(hb,'position',[ .1 .001 .25 .05],'string','show 3D-otsu', 'callback',@pb_otsu3Dmontage);
%     set(hb,'fontsize',7,'backgroundcolor','w');
%     set(hb,'tooltipstring',['3D-Otsu - show all slices ' char(10) ' ']);
%     
    
    % ===============================================================

    set(gcf,'WindowKeyPressFcn',@keys_otsu);
else
    figure(hf2);
    %     'ro'
end

medfltval   =str2num(get(findobj(hf2,'tag','otsu_medfilt_val'),'string'));
numcluster  =str2num(get(findobj(hf2,'tag','ed_otsu'),'string'));
do3d=get(findobj(hf1,'tag','rd_otsu3d'),'value');

 if isempty(numcluster); return; end
 
% OTSU 2D/3D
if do3d==1                                         %3d
%     if isfield(u,'otsu')==0 || numcluster~= u.set.otsu_numClasses
%         v=reshape(  otsu(u.a(:),numcluster),[ size(u.a) ]);
%         u.otsu=v;
%         u.set.otsu_numClasses=numcluster;
%         set(hf1,'userdata',u);
%     end
    
    %--------------
    
    
    if isfield(u,'otsu')==0 ||  isfield(u,'otsu3D_numClasses')==0 ||  numcluster~= u.set.otsu3D_numClasses
        disp('otsu3d');
        hf1=findobj(0,'tag','xpainter');
        u=get(hf1,'userdata');
        a=u.a;
        b=u.b;
        %      a=permute(u.a,[setdiff([1:3],u.usedim) u.usedim]);
        %      b=permute(u.b,[setdiff([1:3],u.usedim) u.usedim]);
        
        %med-filter
        if get(findobj(hf2,'tag','otsu_medfilt_rd'),'value')==1
            [a] = ordfilt3D(a,medfltval);
        end
        
        %ot=getslice2d();
        ot3=reshape(  otsu(a(:),numcluster),[ size(a)]);
        
        u.otsu=ot3;
        u.set.otsu3D_numClasses=numcluster;
        set(hf1,'userdata',u);
    end
    
    ot3=permute(u.otsu,[setdiff([1:3],u.usedim) u.usedim]);
    ot=ot3(:,:,u.useslice);
    
    
    %--------------

    
    %ot=getslice2d(u.otsu);
    
    if get(findobj(hf1,'tag','rd_transpose'),'value')==1
        %x=permute(r2, [2 1 3]);
        ot=ot';
        %ot3=permute(ot3,[2 1 3]);
    end
    if get(findobj(hf1,'tag','rd_flipud'),'value')==1
        ot =flipud(ot);
        %ot3=flipdim(ot,2);
    end
    
    
else%2d
    
    %med-filter
    if get(findobj(hf2,'tag','otsu_medfilt_rd'),'value')==1
        r1=medfilt2(r1,[medfltval medfltval],'symmetric');
    end
    
   
    ot=otsu(r1,numcluster);
end


% ----------
if 0
    ox=ot;
    ox(ox==1)=0;
    ma=double(label2rgb(ox,'jet'));
    bg=repmat( (imadjust(mat2gray(r1))),[1 1 3]);
    
    fg,imshow(bg.*.9+ma.*0.1)
end
% ----------


hp=findobj(hf2,'tag','pb_otsouse');
if do3d==1
    set(hp,'enable','on');
else
    set(hp,'enable','off');
end

if sum(~isnan(unique(ot(:))))==0
    set(findobj(hf2,'type','image'),'visible','off');
    return
else
    
    try
        set(findobj(hf2,'type','image'),'visible','on');
    end
end

him2=imagesc(ot);
caxis([0 max(ot(:))]);
ax2=get(him2,'parent');
set(him2,'ButtonDownFcn',{@pb_otsouse,1})
set(ax2,'units','norm','position',[0 0 1 1]);
axis off

axis image;
drawnow;
set(hf2,'Pointer','arrow');
drawnow;
% pause(1);
% drawnow
% get(hf2,'tag')

% for i=1:100; set(hf2,'Pointer','arrow'); drawnow; end

% return
pb_otsucut([],[],[]);

% drawnow
% set(gcf,'Pointer','custom');drawnow
% % pointer=ones(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
% % set(gcf,'PointerShapeCData',pointer);drawnow
% % pointer=nan(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
% set(gcf,'PointerShapeCData',pointer);drawnow
% set(gcf,'PointerShapeCData',pointer);drawnow
% set(gcf,'pointer','cross');



%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   make 3d-otsu-fig
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
function otsu3Dmontage_mkfig();
fg; 
set(gcf,'name','OTSU-3D','NumberTitle','off','tag','otsu3d');
% him=image(uint8(cat(3,0,0,255)));
% axis off
% set(gca,'position',[0.2 .1 .8 .9]);
v.him=[];
set(gcf,'userdata',v);


% 3d-OTSU                                           3d-OTSU
% ========classes=======================================================
%otsu -number of classes-label
hb=uicontrol('style','text','units','norm', 'string' ,'classes');
set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
set(hb,'position',[0 .95 .12 .04],'HorizontalAlignment','left');
set(hb,'tooltipstring',['otsu define number of classes/clusters' char(10) '--']);
%otsu -number of classes
hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu3_numclasses','value',0);
set(hb,'position',[ .12 .95 .05 .04],'string','3', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu3D: define number of classes/clusters' char(10) '--']);
% =========median-filter======================================================
%medianfilter-radio
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_medfilt_rd','value',1);
set(hb,'position',[0 .91 .12 .04],'string','medfilt', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
set(hb,'tooltipstring',['median filter image prior otsu3D' char(10) '-']);
%medianfilter-filtervalue
hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu3_medfilt_ed');
set(hb,'position',[.12 .91 .05 .04],'string','3', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['median filter length' char(10) '-']);

 % =========crop======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_crop','value',1);
set(hb,'position',[0 .78 .12 .04],'string','crop slices', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
set(hb,'tooltipstring',['crop slices for better montage' char(10) '-']);

% =========contour======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3Dmontage_contour','value',0);
set(hb,'position',[0 .74 .12 .04],'string','contour', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
set(hb,'tooltipstring',['show contour' char(10) '-']);

% =========alpha======================================================

hb=uicontrol('style','text','units','norm');
set(hb,'position',[0 .7 .12 .04],'string','transparency');
set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
set(hb,'tooltipstring',['transparency/alpha: [0-1] range' char(10) '-']);

hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu3D_alpha','value',0);
set(hb,'position',[0.12 .7 .05 .04],'string','.4', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','normal');
set(hb,'tooltipstring',['transparency/alpha: [0-1] range' char(10) '-']);



 % =========fuse image======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_bgfgfuse','value',1);
set(hb,'position',[0 .6 .14 .04],'string','fuse BG+FG', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor',[ 0.9373    0.8667    0.8667],'fontweight','normal');
set(hb,'tooltipstring',['show background /foreground image' char(10) '-']);
 % =========BG/FG======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_bgfg','value',0);
set(hb,'position',[0 .56 .14 .045],'string','BG or FG', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor',[ 0.9373    0.8667    0.8667],'fontweight','normal');
set(hb,'tooltipstring',['show [0] background image or [1]foreground image' char(10) '-']);



 % =========all slices======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_applyAllSlices','value',1);
set(hb,'position',[0 .4 .12 .04],'string','all slices', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor',[1 0.83 0],'fontweight','normal');
set(hb,'tooltipstring',['[1] apply selection on all slices' char(10) '[0] apply only on current slice' char(10) '-']);

set(gcf,'WindowButtonDownFcn',@pb_otsu3D_transmit);



%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   main caller for 3d-otsu
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
function pb_otsu3D(e,e2)
hf=findobj(0,'tag','otsu3d');
 delete(hf);
 if get(e,'value')==0
    return
end
otsu3Dmontage_mkfig();
otsu3Dmontage_plot([],[]);
% pb_otsu3Dmontage();


%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   prep otsu
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
function otsu3Dmontage_plot(e,e2)
% disp('otsu3d');
% 'aaa'
hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');
numcluster  =str2num(get(findobj(hf3,'tag','otsu3_numclasses'),'string'));
medfltval   =str2num(get(findobj(hf3,'tag','otsu3_medfilt_ed'),'string'));
medfltdo    =get(findobj(hf3,'tag','otsu3_medfilt_rd'),'value');
docrop      =get(findobj(hf3,'tag','otsu3_crop'),'value');
alpha       =str2num(get(findobj(hf3,'tag','otsu3D_alpha'),'string'));

a=u.a;
b=u.b;
%med-filter
if medfltdo==1
    for i=1:size(a,3)
        %a(:,:,i)=adjustIntensity(a(:,:,i))
        a(:,:,i)=medfilt2(a(:,:,i),[medfltval medfltval]);
    end
        %[a] = ordfilt3D(a,medfltval);
end

%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   % ADJUST IMAGE
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
% disp('adjust 3d-volume');
[as hs]=montageout(permute(a,[1 2 4 3]));
as=adjustIntensity(as);
si=size(as)./hs;
as2=zeros(size(a));
n=1;
for i=1:hs(1)
    for j=1:hs(2)
        mi=i*si(1)-si(1)+1:i*si(1)-si(1)+si(1) ;
        mj=j*si(2)-si(2)+1:j*si(2)-si(2)+si(2);
        if n<=size(a,3)
            as2(:,:,n)=as(mi,mj);
            n=n+1;
            %disp(n);
        end
    end
end
a=as2;
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�


ot3=reshape(  otsu(a(:),numcluster),[ size(a)]);
v=get(hf3,'userdata');
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
o=ot3 ;%u.otsu;
a=u.a;
TX=repmat(permute([1:size(a,3) ]',[3 2 1]),[size(a,1)  size(a,2)  1]); %for slicewise-reversing
o =permute( o,[setdiff([1:3],u.usedim) u.usedim]);
a =permute( a,[setdiff([1:3],u.usedim) u.usedim]);
TX=permute(TX,[setdiff([1:3],u.usedim) u.usedim]);
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    o=permute(o,[2 1 3]);
    a=permute(a,[2 1 3]);
    TX=permute(TX,[2 1 3]);
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    o=flipdim(o,1);
    a=flipdim(a,1);
    TX=flipdim(TX,1);
end

v.a=a;
v.o=o;
v.TX=TX;

if docrop==1        %------------------------- CROP
    cm=mean(o,3)==1 ;%crop
    cm=imdilate(cm,strel('square',[7]));
    v.ins_lr=find(mean(cm,1)~=1);
    v.ins_ud=find(mean(cm,2)~=1);
   o  =o(v.ins_ud, v.ins_lr,:);
   a  =a(v.ins_ud, v.ins_lr,:);
   TX =TX(v.ins_ud, v.ins_lr,:);
else
   v.ins_lr=[1:size(o,2)]; 
   v.ins_ud=[1:size(o,1)]; 
end

v.o1=o; %after cropping
v.TX1=TX;

o2 =montageout(permute(o ,[1 2 4 3]));
a2 =montageout(permute(a ,[1 2 4 3]));
TX2=montageout(permute(TX,[1 2 4 3]));

%________________________________________________colorize
numcols=unique(o);
numcols(numcols==0)=[];
colmat = distinguishable_colors(max(numcols),[1 1 1; 0 0 0]);
ra=reshape( o            , [ size(o,1)*size(o,2)*size(o,3)   1 ]);
rb=repmat(ra.*0,[1 3]);
for i=1:length(numcols)
    ix=find(ra==numcols(i));
    rb( ix ,:)  = repmat(colmat(numcols(i),:), [length(ix) 1] );
end
rb=reshape(rb,[ size(o,1) size(o,2) size(o,3)  3]);
clear ma
ma(:,:,1)=montageout(permute(rb(:,:,:,1),[1 2 4 3]));
ma(:,:,2)=montageout(permute(rb(:,:,:,2),[1 2 4 3]));
ma(:,:,3)=montageout(permute(rb(:,:,:,3),[1 2 4 3]));

bg=imadjust(mat2gray(a2));
bg=round(bg.*255);
bg=im2double(uint8(cat(3,bg,bg,bg)));
% bg=double(ind2rgb( round(mat2gray(a2).*255) ,gray));
% ma=im2double(label2rgb(o2,'jet'));
% fg,image(bg)
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
fus3=(bg.*(1-alpha)+ma.*(alpha)  );
v.him=findobj(gca,'type','image');
if ~isempty(v.him) ; set(v.him,'cdata',fus3); else;     v.him=image(fus3); end
% fg,
% image(bg.*(1-alp)+ma.*(alp)  );
% % fg,image(ma.*(alp)  )
axis off
set(gca,'position',[0.2 .1 .75 .9]);
xlim([.5 size(fus3,2)+.5]);       ylim([.5 size(fus3,1)+.5]);
% --------------
v.numcols=numcols;
v.colmat=colmat;
v.bg=bg;
v.ma=ma;
v.fus3=fus3;
v.o2=o2; %2d otsu montage
v.ot3=ot3;
v.TX2=TX2;
set(gcf,'userdata',v);

 set(gca,'position',[0.175 .0 .825 1]);
 set(gcf,'WindowButtonMotionFcn',@otsu3d_motion);
 
 
 axis off;
 
hs=uicontrol('style','text','units','normalized','string','current cluster');
set(hs,'backgroundcolor','k','foregroundcolor',[1 .85 0],'tag','tx_selected_cluster');
set(hs,'position',[0.001 0 .173 .08],'fontweight','bold','fontsize',9,'string',{'current cluster' '--'});

 function otsu3d_motion(e,e2);

%      return
     
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])); %right-down
% disp(co)
xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
   %'out'
   return ;
 else ;%     'in'
end

hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');
v=get(hf3,'userdata');
val=v.o2(co(2),co(1));
% disp(val);
hs=findobj(gcf,'tag','tx_selected_cluster');
if val==0
    valstr=' - ';
else
    valstr=num2str(val);
end
set(hs,'string',{'current cluster' valstr});  
     
     
     
 
 %覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   otsu_transmit 3d
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
function pb_otsu3D_transmit(e,e2);
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])) ;%right-down

xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
    return ;%'out'
% else ;%     'in'
end



hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');

% disp(co)
v=get(hf3,'userdata');
val=v.o2(co(2),co(1));
mp=v.o2==val;

reg=v.o1==val;
[cl numsubslust] =bwlabeln(reg);
tb=[[1:numsubslust]' histc(cl(:),1:numsubslust)];
dum1 =cl(:);
dum2=dum1(:)*0;
tb=tb(tb(:,2)>100,:);
for i=1:size(tb,1)
   dum2(dum1==tb(i,1))=i; 
end
cl=reshape(dum2, size(reg));
numsubslust=size(tb,1);

cl2 =montageout(permute(cl,[1 2 4 3]));
% clrgb=im2double(label2rgb(cl2,'jet'));

%________________________________________________colorize
numcols=unique(cl);
numcols(numcols==0)=[];
colmat = distinguishable_colors(max(numcols),[1 1 1; 0 0 0]);
ra=reshape( cl           , [ numel(cl) 1 ]);
rb=repmat(ra.*0,[1 3]);
for i=1:length(numcols)
    ix=find(ra==numcols(i));
    rb( ix ,:)  = repmat(colmat(numcols(i),:), [length(ix) 1] );
end
rb=reshape(rb,[ size(cl)  3]);
clear ma
clrgb(:,:,1)=montageout(permute(rb(:,:,:,1),[1 2 4 3]));
clrgb(:,:,2)=montageout(permute(rb(:,:,:,2),[1 2 4 3]));
clrgb(:,:,3)=montageout(permute(rb(:,:,:,3),[1 2 4 3]));


 
alpha=.6;
fus4=(v.bg.*(1-alpha)+clrgb.*(alpha)  );
fg,imagesc( fus4);
set(gcf,'WindowButtonDownFcn',@otsu3d_selectsubcluster);
set(gcf,'WindowButtonMotionFcn',@otsu3d_subclustermotion);
v.inf3='*** sub-cluster-selection ***';
v.cl =cl;
v.cl2=cl2;
% title({['#clusters: ' num2str(numsubslust)];['\fontsize{16}black {\color{magenta}magenta click cluster']})

%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   title subcluster
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
ti=title(['\fontsize{10}  -->  { ' ...
'\color[rgb]{0 0 1} Cluster-' num2str(val) ...   
'\color[rgb]{0 0 0} contains  '  ...
'\color[rgb]{1 0 0} '  num2str(numsubslust)  ' Subclusters'  char(10)...   
'\color[rgb]{0 .5 .5} Click onto cluster to submit this cluster.}  '...
]);
pos=get(ti,'position');
set(ti,'position',[ 100 pos(2) 0],'HorizontalAlignment','left');
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
set(hf3,'userdata',v);

axis off;
set(gca,'position',[.097 .005 .9 .9]);
hs=uicontrol('style','text','units','normalized','string','current cluster');
set(hs,'backgroundcolor','k','foregroundcolor',[1 .85 0],'tag','tx_selected_subcluster');
set(hs,'position',[0.7 0.905 .297 .04],'fontweight','bold','fontsize',10);

function otsu3d_subclustermotion(e,e2)
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])); %right-down
% disp(co)
xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
   %'out'
   return ;
 else ;%     'in'
end

try
    hf1=findobj(0,'tag','xpainter');
    hf3=findobj(0,'tag','otsu3d');
    u=get(hf1,'userdata');
    v=get(hf3,'userdata');
    val=v.cl2(co(2),co(1));
    % disp(val);
    hs=findobj(gcf,'tag','tx_selected_subcluster');
    if val==0
        valstr=' - ';
    else
        valstr=num2str(val);
    end
    set(hs,'string',[ 'current cluster: ' valstr ]);
end

function otsu3d_selectsubcluster(e,e2)
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])); %right-down
% disp(co)
xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
   %'out'
   return ;
 else ;%     'in'
end

hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');
v=get(hf3,'userdata');
if isempty(v)
    warndlg('otsu3d main window was closed...can''t proceed ');
    return
end
val=v.cl2(co(2),co(1));
mp=v.cl2==val;
if val==0; return; end

%--------backtrafo
b1=zeros(size(v.o1));


for i=1:size(b1,3)
  ix=find(v.TX2==i);
  tt=reshape(  mp(ix), [length(v.ins_ud) length(v.ins_lr)] );
  b1(:,:,i)=tt;
end
% ------deCrop
%get(findobj(hf3,'tag','otsu3_crop'),'value')
% if ~isempty(v.ins_lr) || ~isempty(v.ins_ud)
b2=zeros(size(v.o));
% fill background image if image is croped and subcluster is at the border
if get(findobj(hf3,'tag','otsu3_crop'),'value')==1 %croped image
    bord=mp([1 end],:,:);bord=bord(:);
    bord=mp(:,[1 end],:);bord=[bord(:); bord(:)];
    if [sum(bord>0)./length(bord)>.5]
        b2=ones(size(b2));
    end
end
b2(v.ins_ud, v.ins_lr,:)=b1;
% end
% ------flipdim
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    b2=flipdim(b2,1);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    b2=permute(b2,[2 1 3]);
end

% ------------ update mask
ix=find(b2(:)==1);
up=u.b(:);
up(ix)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
up2=reshape(up,size(b2));

u.b=up2;
set(hf1,'userdata',u);
figure(hf1);
setslice();




return

% 
% o=ot3 ;%u.otsu;
% a=u.a;
% TX=repmat(permute([1:size(a,3) ]',[3 2 1]),[size(a,1)  size(a,2)  1]); %for slicewise-reversing
% o =permute( o,[setdiff([1:3],u.usedim) u.usedim]);
% a =permute( a,[setdiff([1:3],u.usedim) u.usedim]);
% TX=permute(TX,[setdiff([1:3],u.usedim) u.usedim]);
% if get(findobj(hf1,'tag','rd_transpose'),'value')==1
%     o=permute(o,[2 1 3]);
%     a=permute(a,[2 1 3]);
%     TX=permute(TX,[2 1 3]);
% end
% if get(findobj(hf1,'tag','rd_flipud'),'value')==1
%     o=flipdim(o,1);
%     a=flipdim(a,1);
%     TX=flipdim(TX,1);
% end


 
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   otsu3Dmontage_post
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
function otsu3Dmontage_post(e,e2)
% 'post3d'
hf3=findobj(0,'tag','otsu3d');
v=get(hf3,'userdata');

% if strcmp(get(e,'tag'),'otsu3D_alpha')
alpha      =str2num(get(findobj(hf3,'tag','otsu3D_alpha'),'string'));
docontour  =       (get(findobj(hf3,'tag','otsu3Dmontage_contour'),'value'));

hfuse=findobj(hf3,'tag','otsu3_bgfgfuse');
hbgfg=findobj(hf3,'tag','otsu3_bgfg');
dofuse     =       get(hfuse,'value');
showbgfg   =       get(hbgfg,'value');

if strcmp(get(e,'tag'),'otsu3_bgfg')
     if showbgfg==0  %BG-image
       dx=v.bg; 
    else             %FG-image
      dx=v.ma;
    end
    set(hfuse,'value',0);
else %FUSE
    if dofuse==1
        set(hbgfg,'value',0)
        v.fus3=(v.bg.*(1-alpha)+v.ma.*(alpha)  );
        dx=v.fus3;
    else
        set(hbgfg,'value',0);
        set(hfuse,'value',0);
        otsu3Dmontage_post(hbgfg,[]);
        return
    end
end    
if dofuse==0
    set(hfuse,'value',0);
    if showbgfg==0  %BG-image
       dx=v.bg; 
    else             %FG-image
      dx=v.ma;
    
    end
end %fuse

v.him=findobj(gca,'type','image');
if ~isempty(v.him);    set(v.him,'cdata',dx);
else;                  v.him=image(dx);
end;
xlim([.5 size(dx,2)+.5]);       ylim([.5 size(dx,1)+.5]);

set(gcf,'userdata',v);


if docontour==1
    hold on;contour(v.o2,size(v.numcols,1));
    colormap(v.colmat);
else
    delete(findobj(gca,'type','contour'));
end






%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   otsu-2d !!!
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�


function pb_otsucut(e,e2,par)
hf=findobj(0,'tag','otsu');
him2=findobj(hf,'Type','image');
if get(findobj(hf,'tag','pb_otsucut'),'value')==1  % CUT-OTSU
    
    set(him2,'ButtonDownFcn',[]);
    set(hf,'WindowButtonDownFcn',{@selcut,1});
    set(hf,'WindowButtonUpFcn' ,{@selcut,0});
    set(hf,'WindowButtonMotionFcn',@otsumotion);
    
    o=get(hf,'userdata');
    o.docut=0;
    set(hf,'userdata',o);
    xl=xlim; yl=ylim; xlim(xl);ylim(yl);
    
    % disp(get(gcf,'selectiontype'))
    
else % transfer cluser
    set(him2,'ButtonDownFcn',{@pb_otsouse,1});
    set(hf,'WindowButtonDownFcn',[]);
    set(hf,'WindowButtonUpFcn' ,[]);
    set(hf,'WindowButtonMotionFcn',[]);
end



function selcut(e,e2,isBttnDown)
% arg
hf=findobj(0,'tag','otsu');
o=get(hf,'userdata');
o.docut=isBttnDown;

o.lastpoint=[];



if o.docut==1
    
    %     disp(get(gcf,'selectiontype'));
    selectionType=get(gcf,'selectiontype');
    if strcmp(selectionType,'alt')
        pb_otsouse([],[],1)
    end
end
set(hf,'userdata',o);
% disp(o);

if get(findobj(hf,'tag','pb_otsucut'),'value')==1 && isBttnDown==0 %% cutting=on, but BTTN relased
    %     isBttnDown
    %     him2=findobj(hf,'Type','image');
    %     dx=get(him2,'cdata');
    %     d=dx==0;
    o.lastpoint=[];
    set(hf,'userdata',o);
end

function otsumotion(e,e2)
hf=findobj(0,'tag','otsu');
o=get(hf,'userdata');
him2=findobj(hf,'Type','image');


try
    if o.docut==1
        co=round(get(gca,'CurrentPoint'));
        

        dx=get(him2,'cdata');
        if co(1,2)<=size(dx,1) && co(1,1)<=size(dx,2) && co(1,2)>0 && co(1,1)>0
            dx(co(1,2),co(1,1))=0;
            
            
            if 1 %interpolate
                if isempty(o.lastpoint)==0
            
                    cola=o.lastpoint;
%                     if max(abs(cola(1,1:2)-co(1,1:2)))>1
                     % disp('flass');
                        x=[cola(1,1) co(1,1)];
                        y=[cola(1,2) co(1,2)];
                        stp=15*max(abs(x-y));
                        x1=round(linspace(x(1),x(2),stp));
                        y1=round(linspace(y(1),y(2),stp));
                        ix=sub2ind([size(dx)], y1, x1);
                        dx(ix)=0;
%                     end
%                     xx=sort([o.lastpoint(1,1) co(1,1)]);
%                     yy=sort([o.lastpoint(1,2) co(1,2)]);
%                     disp([o.lastpoint(1,1:2)  co(1,1:2)]);
                    
%                     lin=[[xx(1):xx(2)]' [yy(1):yy(2)]'];
                 
                end
                o.lastpoint=co;
                set(hf,'userdata',o);
            end

            
            set(him2,'cdata',dx);
        end
%         rand(1)
%         drawnow;
    end
end



function pb_otsouse(e,e2,par)
if exist('par')==0; par=2; end

hf1=findobj(0,'tag','xpainter');
hf2=findobj(0,'tag','otsu');
u=get(hf1,'userdata');

figure(hf2);
 
% selectionType=get(gcf,'selectiontype')
% if strcmp(selectionType,'alt')
%    hb= findobj(hf2,'tag','pb_otsucut')
%    set(hb,'value',1)
%   
%     him2=findobj(hf2,'Type','image');
%     set(him2,'ButtonDownFcn',[]);
%     set(hf2,'WindowButtonDownFcn',{@selcut,1});
%     set(hf2,'WindowButtonUpFcn' ,{@selcut,0});
%     set(hf2,'WindowButtonMotionFcn',@otsumotion);
%     
%     
% %     otsumotion()
%     
%     o=get(hf2,'userdata');
%     o.docut=0;
%     set(hf2,'userdata',o);
%     xl=xlim; yl=ylim; xlim(xl);ylim(yl);
%    
%    
%     return
% end

if par==2 || par==3
    [x y]=ginput(1);
    set(gcf,'Pointer','arrow');
    %     disp('x-y');
    %     [x y]
    %     disp('cp');
    cor=get(gca,'CurrentPoint');
else
    
    
    
    
    set(gcf,'Pointer','arrow');
    cor=get(gca,'CurrentPoint');
    x=cor(1,1);  y=cor(1,2);
end
% return
xb=x;
yb=y;

figure(hf1);
dx=get(findobj(hf2,'type','image'),'cdata');
val=dx(round(y),round(x));

valotsu=val;
dx2=bwlabel(dx==val,4);
m=double(dx2==dx2(round(y),round(x)));


dims=u.dim(setdiff(1:3,u.usedim));
bw = m;
%         if u.usedim==3
r1=getslice2d(u.a);
r2=getslice2d(u.b);
r1=adjustIntensity(r1);


if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end

%             r1=u.a(:,:,u.useslice);
%             r2=u.b(:,:,u.useslice);
si=size(r2);
r2=r2(:);
% if type==1
r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
% elseif type==2
%     r2(bw==1)  =  0;
% end

r2=reshape(r2,si);

%===== update history
% r2=getslice2d(u.b);
u.histpointer=u.histpointer+1;

r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end
u.hist(:,:,u.histpointer)=r2n;



% disp(u);
% set(gcf,'userdata',u);




alp=u.alpha;% .8
% val=unique(u.b); val(val==0)=[];
r2v=r2(:);
r1=mat2gray(r1);
ra=repmat(r1,[1 1 3]);

rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
val=unique(r2); val(val==0)=[];
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
rm=sum(rb,2);
im=find(rm~=0);
% s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
x=reshape(s1,size(ra));


set(u.him,'cdata',   x  );


% u=putsliceinto3d(u,r2,'b');
r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end
u=putsliceinto3d(u,r2n,'b');


set(gcf,'userdata',u);
him=findobj(gcf,'tag','image');


if par==3 %replace
    %%     f = msgbox('this will overwrite the entire mask')
    answer = questdlg('this will replace the entire mask over all slices..proceed?', ...
        '', 	'yes','no','dd');
    if strcmp(answer,'no'),'return'; end
    
    ot3=u.otsu;
    ot3=double(ot3==valotsu);
    sm=strel('disk',2);
    ot3=imdilate( imerode( ot3  ,sm)  ,sm);
    ot4=bwlabeln(ot3,6);
    
    u.ot4=ot4;
    bv=getslice2d(u.ot4);
    clustnum=bv(round(yb),round(xb));
    ot5=zeros(size(ot4));
    ot5(ot4==clustnum)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
    %     ot3(ot3==1)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
    
    % montage2(ot5)
    
    u.b=ot5;
    set(hf1,'userdata',u);
end


hb=findobj(gcf,'tag','pb_nextstep');
hgfeval(get( hb ,'callback'),[], 1);

drawnow;
% figure(hf1);
% %----------------
% hf1=findobj(0,'tag','xpainter');
% figure(hf1);


figure(hf2);


function pb_undoredo(e,e2,direction)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

% if ~histpointer
if direction==-1
    if u.histpointer>1
        u.histpointer=u.histpointer+direction;
    else
        return;
    end
elseif direction==+1
    if u.histpointer<size(u.hist,3)
        u.histpointer=u.histpointer+direction;
    else
        return;
    end
end

r2=u.hist(:,:,u.histpointer);
u=putsliceinto3d(u,r2,'b');
set(gcf,'userdata',u);


setslice([],'noupdate');


function rd_flipud(e,e2)
setslice();

function rd_transpose(e,e2)
setslice();


function setslice(par,histupdate)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
alp=u.alpha;% .8
if exist('par')==1
    if par==1
        alp=0;
    end
    
end

r1=getslice2d(u.a);
r2=getslice2d(u.b);


if 0
    i=mat2gray(r1);
    i1=imadd(i,100);
    i2=imsubtract(i,50);
    i3=immultiply(i,0.5);
    i4=imdivide(i,0.5);
    i5=imcomplement(i);
    %     fg;imagesc(i5); colormap gray
    r1=i5;
end


if exist('histupdate')~=1
    u.hist       =r2;
    u.histpointer=size(u.hist,3);
    set(hf1,'userdata',u);
    %     disp(u);
end

% if u.usedim==3
%     r1=u.a(:,:,u.useslice);
%     r2=u.b(:,:,u.useslice);
% end

r1=mat2gray(r1);
r1=adjustIntensity(r1);


% if 0
%     'flt'
%     r1=imgaussfilt(r1,.75);
% end

ra=repmat(r1,[1 1 3]);

% if 0
%     rx=r2./max(r2(:));
%     rb=cat(3,rx,rx.*0,rx.*0);
% end

val=unique(u.b); val(val==0)=[];
if length(val)>size(u.colmat,1)
    u.colmat=distinguishable_colors(length(val),[1 1 1; 0 0 0]);
    set(hf1,'userdata',u);
end

r2v=r2(:);
rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]); %GBimage
rm=sum(rb,2);
im=find(rm~=0);
% s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
x=reshape(s1,size(ra));

%------------


% ----------------------------------------------------
%% transpose
htran=findobj(hf1,'tag','rd_transpose');
doTrans=get(htran,'value');
if doTrans==1
    x=permute(x, [2 1 3]);
end
%% flipud
hflip=findobj(hf1,'tag','rd_flipud');
if get(hflip,'value')==1
    x=flipud(x);
end
% ----------------------------------------------------
if isempty(u.him)
    u.him=image(  x );
    %u.him=image(  (ra*alp)+(rb*(1-alp))   );
else
    set(u.him,'cdata',  x );
    %set(u.him,'cdata',   (ra*alp)+(rb*(1-alp))    );
end
set(findobj(gcf,'tag'  ,'edslice'),'string',u.useslice);
set(findobj(gcf,'tag'  ,'edalpha'),'string',u.alpha);
axis image;  axis off;
set(gca,'position',[0 0 .8 .9]);

if size(x,2)>250
    axis square; axis manual;
end
adjustAxesPosition()
% xl=xlim;
xlim([.5 size(x,2)+.5]);
% yl=ylim;
ylim([.5 size(x,1)+.5]);


definedot();
set(u.him,'ButtonDownFcn', @sel);
% set(hf1,'WindowButtonUpFcn', @selup);
% set(h  ,'ButtonDownFcn', @sel)
set(gca  ,'ButtonDownFcn', @sel);
set(gcf,'userdata',u);
%
% xlim([0.5 size(ra,2)+.5]);
% ylim([0.5 size(ra,1)+.5]);

%otsu updat
hf1=findobj(0,'tag','xpainter');

if get(findobj(hf1,'tag','rd_otsu'),'value')==1
    if exist('histupdate')~=1
        pb_otsu([],[]);
    end
    
    figure(hf1);
end
% pb_measureDistance_off(); %remove measuring tool
% pb_measureDistance_off();



function adjustAxesPosition()
hf1=findobj(0,'tag','xpainter');

hp=findobj(hf1,'tag','panel1');
set(hp,'units','norm');
norpos1=get(hp,'position');
set(hp,'units','pixels');

hp2=findobj(hf1,'tag','panel2');
set(hp2,'units','norm');
norpos2=get(hp2,'position');
set(hp2,'units','pixels');

% --adjust axes
hax=findobj(hf1,'type','axes');
axpos=get(hax,'position');
axpos=[0 0  norpos2(1)  norpos1(2)];
set(hax,'position',axpos);


%===================================================================================================
function resizefig(e,e2)
hf1=findobj(0,'tag','xpainter');
hp=findobj(hf1,'tag','panel1');
% pixpos=get(hp,'position');
set(get(hp,'children'),'units','pixels');
set(hp,'units','norm');
norpos1=get(hp,'position');
norpos1=[0 1-norpos1(4) norpos1(3:4)];
set(hp,'position',norpos1);
set(hp,'units','pixels');


hp2=findobj(hf1,'tag','panel2');
% pixpos=get(hp,'position');
set(get(hp2,'children'),'units','pixels');
set(hp2,'units','norm');
norpos2=get(hp2,'position');
norpos2=[1-norpos2(3)   0  norpos2(3:4)];
set(hp2,'position',norpos2);
set(hp2,'units','pixels');

% --adjust axes
adjustAxesPosition();




return
% 
% hf1=findobj(0,'tag','xpainter');
% u=get(hf1,'userdata');
% if isfield(u,'controls')==0
%     u.controls=findobj(gcf,'Type','uicontrol');
%     set(u.controls,'units','pixels');
%     u.controls_pospix=get(u.controls,'position');
%     set(u.controls,'units','norm');
%     u.controls_posnorm=get(u.controls,'position');
%     set(hf1,'userdata',u);
% end
% 
% set(u.controls,'units','pixels');
% for i=1:length(u.controls)
%     pos=get(u.controls(i),'position');
%     pos(3:4)=u.controls_pospix{i}(3:4);
%     set(u.controls(i),'position',pos);
% end
% set(u.controls,'units','norm');






% ==============================================
%% make fig
% ===============================================

function makegui
u=get(gcf,'userdata');
u.ax=axes('units','norm','position',[0 0 .8 .8]);

% wait
hb=uicontrol('style','text','units','norm', 'tag'  ,'waitnow');             %CHANGE-DIM
set(hb,'position',[ .93 .97 .07 .03],'string','..wait..','backgroundcolor','k','foregroundcolor',[1.0000 0.8431 0]);
set(hb,'visible','off');
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   PANEL-1
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
pan1 = uipanel('Title','Main Panel','FontSize',7,'units','norm', 'BackgroundColor','white',  'Position',[0 0 .5 .3]);
set(pan1,'Position',[0 .9 1 .1],'Title','','tag','panel1','visible','on','backgroundcolor','w');
set(pan1,'units','pixels','visible','on');
uistack(pan1,'bottom');
%==========================================================================================
%-----CHANGE DIM
str={'1' ,'2' '3'};
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'rd_changedim');             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string',str,'value',3,'backgroundcolor','w');
set(hb,'callback',{@pop_changedim});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['change viewing dimension' char(10) '[d] shortcut']);
set(hb,'parent',pan1);
set(hb,'position',[ .25  .45 .05 .041]); %PAN1
%=============WHICH SLICE=============================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'prev');           %SETL-prev-SLICE
set(hb,'position',[ .35 .9 .05 .04],'string',char(8592), 'callback',{@cb_setslice,'-1'});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['view previous slice' char(10) '[left-arrow] shortcut' ]);
set(hb,'parent',pan1);
set(hb,'position',[ .35  .05 .05 .41]); %PAN1

hb=uicontrol('style','edit','units','norm', 'tag'  ,'edslice');           %EDIT-SLICE
set(hb,'position',[ .4 .9 .05 .04],'string','##','callback',{@cb_setslice,'ed'});
set(hb,'fontsize',8);
set(hb,'tooltipstring','select slice number to view');
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*1  .05 .05 .41]); %PAN1

set(hb,'parent',pan1);
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'next');           %SET-next-SLICE
set(hb,'position',[ .45 .9 .05 .04],'string',char(8594),'callback',{@cb_setslice,'+1'});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['view next slice' char(10) '[right-arrow] shortcut' ]);
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*2  .05 .05 .41]); %PAN1


%==========================================================================================

%transpose image
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_transpose','value',0);
set(hb,'position',[ .12 .95 .08 .04],'string','transpose','callback',{@rd_transpose});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','normal');
set(hb,'tooltipstring',['transpose image']);
set(hb,'position',[ .5 .9 .8 .04]);
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*3  .05 .05*2 .41]); %PAN1

%flipud image
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_flipud','value',0);
set(hb,'position',[ .12 .95 .08 .04],'string','flipud','callback',{@rd_flipud});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','normal');
set(hb,'tooltipstring',['flip up-down image']);
set(hb,'position',[ .58 .9 .08 .04]);
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*5  .05 .05*2 .41]); %PAN1

%==========================================================================================
%-----dotType
str={'dot' ,'square' 'hline' 'vline'};
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'rd_dottype');
set(hb,'position',[ .001  .9 .1 .04],'string',str,'value',1,'backgroundcolor','w');
set(hb,'callback',{@rd_dottype});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['brush type' char(10) '[b] shortcut to alternate between brush types']);
set(hb,'parent',pan1);
set(hb,'position',[ 0 .08 .05*2 .41]); %PAN1

% DOT-SIZE
hb=uicontrol('style','popupmenu','string',{'dotsize'},'value',1,'units','norm','tag','dotsize');
set(hb,'position',[.1  .9 .075 .04],'backgroundcolor','w','tooltipstring','disksize (diameter)');
set(hb,'callback',@definedot);
set(hb,'fontsize',8);
set(hb,'tooltipstring',['brush size' char(10) '[up/down arrow] to change brush size' ]);
set(hb,'parent',pan1);
set(hb,'position',[ 0.1 .08 .05*2 .41]); %PAN1
%==========================================================================================


% unpaint
hb=uicontrol('style','togglebutton','string','unpaint','units','norm','value',0);
set(hb,'position',[.30  .95 .15 .04],'backgroundcolor','w');
set(hb,'callback',@undo,'tag','undo');
set(hb,'fontsize',8);
set(hb,'tooltipstring',['un-paint location' char(10) '[u] shortcut' ]);
set(hb,'parent',pan1);
set(hb,'position',[ 0.3 .5 .05*3 .41]); %PAN1

%==========================================================================================
%TRANSPARENCY
hb=uicontrol('style','edit','units','norm', 'tag'  ,'edalpha');
set(hb,'position',[ .65 .9 .05 .04],'string','##','callback',{@edalpha});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['set transparency {value between 0 and 1}' ]);
set(hb,'parent',pan1);
set(hb,'position',[ .701  .05 .05*1 .41]); %PAN1
%==========================================================================================
%HIDE
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'preview');
set(hb,'position',[ .7 .9 .1 .04],'string','hide mask', 'callback',{@cb_preview});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['shortly hide mask' char(10) '[h] shortcut']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.85 .05 .05*3 .41]); %PAN1
%==========================================================================================

% previois/last step
%==========================================================================================
% LAST-STEP
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_prevstep');
set(hb,'position',[ .5 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,-1});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['UNDO last step' char(10) '..for this slice only' char(10) 'shortcut [ctrl+x] ' ]);
e = which('undo.gif');
%    if ~isempty(regexpi(e,'.gif$'))
[e map]=imread(e);e=ind2rgb(e,map);
set(hb,'cdata', e);
set(hb,'parent',pan1);
set(hb,'position',[ 0.5 .48 .05 .5]); %PAN1

% NEXT-STEP
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_nextstep');
set(hb,'position',[ .54 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,+1});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['REDO last step' char(10) '..for this slice only' char(10) 'shortcut [ctrl+y] ']);
set(hb,'cdata', flipdim(e,2));
set(hb,'parent',pan1);
set(hb,'position',[ 0.55 .48 .05 .5]); %PAN1


%==========================================================================================
%legend
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_legend','value',0);
set(hb,'position',[ .7 .95 .1 .04],'string','legend', 'callback',{@pb_legend});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['show legend' char(10) '[l] shortcut']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.7 .48 .05*1.8 .5]); %PAN1

%slicewise info
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_slicewiseInfo');
set(hb,'position',[ .8 .95 .03 .04],'string','i', 'callback',{@pb_slicewiseInfo});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['show  volume/mask info and slice-wise info' char(10) 'shortcut [i]']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.79 .48 .035 .5]); %PAN1

%overlay-mask all slices
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_show_allslices');
set(hb,'position',[ .83 .95 .03 .04],'string','M', 'callback',{@show_allslices});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['montage: show all slices of bg-image and mask' char(10) 'shortcut [m]']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.825 .48 .035 .5]); %PAN1


%=========OTSU=================================================================================

%otsu -button
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_otsu','value',0);
set(hb,'position',[ .0 .95 .08 .04],'string','otsu', 'callback',{@pb_otsu,1});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu thresholding ' char(10) '[o] shortcut']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.0 .52 .07 .45]); %PAN1

%otsu-3d -button
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_otsu3D','value',0);
set(hb,'position',[ .08 .95 .08 .04],'string','otsu3D', 'callback',@pb_otsu3D);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu-3D thresholding ' char(10) '--']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.07 .52 .07 .45]); %PAN1

%3d-otsu
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_otsu3d','value',0);
set(hb,'position',[ .18 .95 .08 .04],'string','3dotsu','callback',{@pb_otsu,1});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['[]2d vs [x]3d otsu' char(10) '']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.14 .52 .08 .45]); %PAN1

%link otsu
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_otsu');
set(hb,'position',[ .2 .95 .08 .04],'string','link');
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['link otsu : always perform otsu when changing the slice number' char(10) '']);
set(hb,'position',[0.2000    0.9700    0.0800    0.0400]);
set(hb,'visible','off','value',1);






%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   PANEL-2
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
pan2 = uipanel('Title','','FontSize',7,'units','norm', 'BackgroundColor','white',  'Position',[0 0 .5 .3]);
set(pan2,'Position',[0.8 -.01 .21 .915],'tag','panel2','visible','on','backgroundcolor','w');
% set(pan2,'Position',[0.8 0-.01 .205 .9]);
set(pan2,'units','pixels','visible','on');

% CONTRAST adjust slice intensity
hb=uicontrol('style','radio','units','norm', 'tag'  ,'cb_adjustIntensity');
set(hb,'position',[ .8 .8 .1 .035],'string','contrast', 'callback',{@cb_adjustIntensity});
set(hb,'fontsize',7,'backgroundcolor','w','value',0);
set(hb,'tooltipstring',['Saturate contrast, i.e. auto adjust intensity of slice' char(10) '[s] shortcut']);
set(hb,'parent',pan2);
set(hb,'position',[ 0.01 .9 .45 .04]); %PAN2

vec=0:.1:1;
alc=allcomb(vec,vec);
alc=round(alc*10)./10;
alc(alc(:,1)>=(alc(:,2)),:)=[];
% alc(:,3)=[alc(:,2)-alc(:,1)]; % add distance between lims
% alc(:,4)=[abs(alc(:,3)-0.5)];      % distance to 0.5

alc=(sortrows([alc alc(:,2)-alc(:,1)],[1 ]));
alc2=[0 1; .1 .9;.2 .8;.3 .7;.4 .6 ];
% alc=[alc2; alc(:,1:2)];
alc=unique([alc2; alc(:,1:2)],'rows','stable');
% alc= flipud(sortrows([alc alc(:,2)-alc(:,1)],[3 ]));
str=cellfun(@(a,b){[ sprintf('%2.1f',a) ' '  sprintf('%2.1f',b) ]} , num2cell(alc(:,1)),num2cell(alc(:,2)) );
str=['auto';str];
position = [10,100,90,20];  % pixels
hContainer = gcf;  % can be any uipanel or figure handle
% str = {'a','b','c'};
model = javax.swing.DefaultComboBoxModel(str);
[jCombo hb2] = javacomponent('javax.swing.JComboBox', position, hContainer);
set(hb2,'units','norm','position',[[ .9 .805 .1 .035]]);
jCombo.setModel(model);
jCombo.setEditable(true);
% jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 14))
javaLangString=jCombo.getFont;
FSsize=get(javaLangString,'Size');
jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, FSsize-5));
set(jCombo,'ActionPerformedCallback',@cb_adjustIntensity_value);
set(hb2,'tag', 'cb_adjustIntensity_value');
set(hb2,'userdata', jCombo);
set(hb2,'parent',pan2);
set(hb2,'position',[ 0.5 .9 .45 .04]); %PAN2

% idxset=find(alc(:,1)==.3 & alc(:,2)==.7)-1;
try
 jCombo.setSelectedIndex(0); %turn it on!!!
end
jCombo.setToolTipText('contrast limits for image saturation');



%==========================================================================================
% EDIT-VALUE (value to be set)
hb=uicontrol('style','edit','units','norm', 'tag'  ,'edvalue');
set(hb,'position',[ .85 .9 .05 .04],'string','1');
set(hb,'fontsize',8,'callback',@edvalue,'HorizontalAlignment','left');
set(hb,'tooltipstring',['value/ID to be set ...this numeric value will appear in the mask..and later saved']);
set(hb,'position',[ .95 .6 .08 .04]);
set(hb,'parent',pan2);
set(hb,'position',[0.62 .7 .35 .04]); %PAN2
%==========================================================================================
%ID-LIST
hb=uicontrol('style','listbox','units','norm', 'tag'  ,'pb_idlist','value',1);
set(hb,'position',[ .7 .95 .1 .04],'string','', 'callback',{@pb_idlist});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['id list']);
set(hb,'position',[.95 .25 .07 .35]);
set(hb,'parent',pan2);
set(hb,'position',[.62 .35 .4 .35]); %PAN2





%==========================================================================================
% %load file
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_load','value',0);
% set(hb,'position',[ .0 .95 .1 .04],'string','load file', 'callback',{@pb_load,1});
% set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
% set(hb,'tooltipstring',['load file' char(10) '']);
% %load mask
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_loadmask','value',0);
% set(hb,'position',[ .1 .95 .1 .04],'string','load mask', 'callback',{@pb_load,2});
% set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
% set(hb,'tooltipstring',['(optional) load additional maskfile' char(10) 'mask file will be overlayed']);
%==========================================================================================
%save file
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_save');
set(hb,'position',[ .9 .02 .1 .04],'string','save mask', 'callback',{@pb_save});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['save new mask as niftifile' char(10) '']);
set(hb,'parent',pan2);
set(hb,'position',[ .3 .02 .5 .04]); %PAN2

%save file-2

hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'pb_saveoptions');
set(hb,'position',[ .86 .052 .14 .04],'string','r');%, 'callback',{@pb_save2});
set(hb,'fontsize',8,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['saving options' char(10) '']);
list={'save: mask [sm]' %'save: masked image [smi]'
    'save background-image: mask-value 0 is filled with 0-values)    [smi00]'
    'save background-image: mask-value 0 is filled with mean-values) [smi0m] '
    'save background-image: mask-value 0 is filled with neighbouring values) [smi0nv]'
    'save background-image: mask-value 1 is filled with 0-values)    [smi10]'
    'save background-image: mask-value 1 is filled with mean-values) [smi1m]'
    'save background-image: mask-value 1 is filled with neighbouring values) [smi1nv]'
    };
set(hb,'string',list);
set(hb,'parent',pan2);
set(hb,'position',[ .3 .07 .7 .04]); %PAN2

%=========config=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'config');           %SET-next-SLICE
set(hb,'position',[ .84 .14 .05 .05],'string','','callback',{@cb_configuration});
set(hb,'fontsize',8,'backgroundcolor','w');
set(hb,'tooltipstring',['configuration' char(10) '' ]);
icon=strrep(which('ant.m'),'ant.m','settings.png');
[e map]=imread(icon)  ;
e=ind2rgb(e,map);
% e(e<=0.01)=nan;
set(hb,'cdata',e);

set(hb,'parent',pan2);
set(hb,'position',[ .0 .945 .2 .06]); %PAN2
%=========HELP=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_help');
set(hb,'position',[ .9 .15 .1 .04],'string','help', 'callback',{@pb_help});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['more help' char(10) '']);
set(hb,'parent',pan2);
set(hb,'position',[ .45 .96 .5 .04]); %PAN2

%=========clear mask=================================================================================
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'clear mask');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string',{'clear slice'; 'clear all slices'},'callback',{@cb_clear});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['clear current slice/clear all slices' char(10) 'shortcut [c]' ]);
set(hb,'parent',pan2);
set(hb,'position',[ .15 .8 .7 .04]); %PAN2

%=========fill something=================================================================================
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'fill');           %SET-next-SLICE
% set(hb,'position',[ .9 .2 .05 .04],'string','fill','callback',{@cb_fill});
% set(hb,'fontsize',8);
% set(hb,'tooltipstring',['fill something' char(10) '' ]);



% ==============================================
%%   imtools
% ===============================================
picon=fullfile(matlabroot,'toolbox','images','icons');
picon2=fullfile(matlabroot,'toolbox','matlab','icons');
chkicon=which('imrect.m');
if ~isempty(chkicon);
    hf1=findobj(0,'tag','xpainter');
    pbsiz=0.05;
    %pbx=0.01%.81;
    pbx=.81;
    pby=.55;
    colpb=[1.0000    0.9490    0.8667];
    
    x=0.01; 
    y=.55;
    xs=.22;
    ys=.07;
    

    
    delete(findobj(hf1,'userdata','imtoolsbutton'));
    delete(findobj(hf1,'tag','imtoolinfolabel'));
    
    %info
    hb=uicontrol('style','text','units','norm', 'tag'  ,'imtoolinfolabel');           %
    set(hb,'fontsize',7,'backgroundcolor','w','value',0,'string','drawing tools');
    set(hb,'position',[ pbx pby+1.1*pbsiz .12 pbsiz/2],'horizontalalignment','left');
    set(hb,'parent',pan2);
    set(hb,'position',[ x y+ys .5 .035]); %PAN2
    
    
    % free-hand drawing
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,   1     });
    setappdata(hb,'toolnr',1);
    set(hb,'tooltipstring',['free-hand drawing' char(10) 'shortcut [1]' ]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x y xs ys]);
    [e map]=imread(fullfile(picon,'Freehand_24px.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % imrect
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  2   });
    setappdata(hb,'toolnr',2);
    set(hb,'tooltipstring',['draw rectangle' char(10) 'shortcut [2]' ]);
    set(hb,'position',[ pbx pby-1*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+0*xs y-1*ys xs ys]);
    
    [e map]=imread(fullfile(picon,'Rectangle_24.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % imellipse
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  3   });
    setappdata(hb,'toolnr',3);
    set(hb,'tooltipstring',['draw ellipse/cirlce' char(10) 'shortcut [3]' ]);
    set(hb,'position',[ pbx+1*pbsiz pby-1*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+1*xs y-1*ys xs ys]);
    [e map]=imread(fullfile(picon,'Ellipse_24.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % impoly
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  4   });
    setappdata(hb,'toolnr',4);
    set(hb,'tooltipstring',['draw polygon' char(10) 'shortcut [4]' ]);
    set(hb,'position',[ pbx+0*pbsiz pby-2*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+0*xs y-2*ys xs ys]);
    [e map]=imread(fullfile(picon,'Polygon_24px.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % imline
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  5   });
    setappdata(hb,'toolnr',5);
    set(hb,'tooltipstring',['draw line' char(10) 'shortcut [5]' ]);
    set(hb,'position',[ pbx+1*pbsiz pby-2*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+1*xs y-2*ys xs ys]);
    [e map]=imread(fullfile(picon2,'tool_line.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'nearest'));
    e=mat2gray(e);
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % h =imfreehand;
    % h=imrect;
    % h=imellipse;
    % h=impoly;
    % h=imline;
    %
    
    % Ellipse_16.png
    % Rectangle_24.png
    % Polygon_24px.png
    % STRELLINE_24.png
end

% ==============================================
%%  distance measure
% ===============================================
chkicon=which('imdistline.m');
if ~isempty(chkicon);
    hf1=findobj(0,'tag','xpainter');
    pbsiz=0.05;
    pbx=.8;
    pby=.38;
    colpb=[0.8392    0.9098    0.8510];
    picon=fullfile(matlabroot,'toolbox','images','icons');
    picon2=fullfile(matlabroot,'toolbox','matlab','icons');

    
    % measure distance
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_measureDistance');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','');
    % ---
    set(hb,'callback',@pb_measureDistance);
    set(hb,'tooltipstring',['measure distance' char(10) '--' ]);
    %set(hb,'position',[ pbx pby pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+0*xs y-3.5*ys xs ys]);
    [e map]=imread(fullfile(picon,'distance_tool.gif'));
    e=mat2gray(e);
    e(e==1)=nan;
    % ---
    %e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    e2=repmat(e,[1 1 3]);
    set(hb,'cdata',e2);
end
% ==============================================
%%  windows-auto focus
% ===============================================
if 1%~isempty(chkicon);
    hf1=findobj(0,'tag','xpainter'); 
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_autofocus');           %SET-next-SLICE
    set(hb,'fontsize',7,'backgroundcolor','w','value',0,'string','WinFocus');
    set(hb,'callback',@rd_autofocus);
    set(hb,'tooltipstring',['autofocus window' char(10) 'window becoms focused (active) when mouse hovers over it' char(10) '[a] shortcut']);
    %set(hb,'position',[ .84 .2 .11 .035]);
    set(hb,'parent',pan2);
    set(hb,'position',[ .2 .2 .6 .035]);
end






function show_allslices(e,e2,px)
% ==============================================
%%   
% ===============================================
% fprintf('..wait...');
hf1=findobj(0,'tag','xpainter');
hw=findobj(hf1,'tag','waitnow');
set(hw,'visible','on'); drawnow;
u=get(hf1,'userdata');
hb=findobj(hf1,'tag','rd_changedim');
dimval=get(hb,'value');
dimlist=get(hb,'string');
dim=str2num(dimlist{dimval});
% dim=

do_transp=get(findobj(hf1,'tag','rd_transpose'),'value');
do_flipud=get(findobj(hf1,'tag','rd_flipud'),'value');



b=u.b(:);
uni=unique(b); uni(uni==0)=[];
c=zeros(size(b,1),3);
for i=1:length(uni)
    %fprintf('%d ',i);
    pdisp(i,20);
    %disp(i)
    ix=find(b==uni(i));
    c(ix,:)=repmat( u.colmat(uni(i),:) ,[ length(ix) 1]);
end
% fprintf('..');
c1=reshape(c(:,1),[u.hb.dim]);
c2=reshape(c(:,2),[u.hb.dim]);
c3=reshape(c(:,3),[u.hb.dim]);

dimother=setdiff(1:3,dim);
c1=permute(c1, [dimother dim]);
c2=permute(c2, [dimother dim]);
c3=permute(c3, [dimother dim]);



d=[];
d(:,:,1)=montageout(permute(c1,[1 2 4 3]));
d(:,:,2)=montageout(permute(c2,[1 2 4 3]));
d(:,:,3)=montageout(permute(c3,[1 2 4 3]));

bg  =permute(u.a, [dimother dim]);
mask=permute(u.b, [dimother dim]);
% r1=adjustIntensity(r1)
% -----
for i=1:size(bg,3)
  %bg(:,:,i)=imadjust(mat2gray(bg(:,:,i)));
  bg(:,:,i)=adjustIntensity(mat2gray(bg(:,:,i)));
end
bg  =montageout(permute(bg,[1 2 4 3]));
mask=montageout(permute(mask,[1 2 4 3]));

% bg=imadjust(mat2gray(montageout(permute(bg,[1 2 4 3]))));
%-----
bg=repmat(bg,[1 1 3]);
% TX=repmat(permute([1:size(c1,3) ]',[3 2 1]),[size(c1,1)  size(c1,2)  1]); %for txtlabel
TX=zeros(size(c1));
for i=1:size(c1,3)
    TX(1,1,i)=i;
end

TX=montageout(permute(TX,[1 2 4 3]));
if do_transp==1
    bg=permute(bg     ,[2 1 3]);
    d =permute( d     ,[2 1 3]);
    TX=permute( TX    ,[2 1 3]);
    mask=permute( mask,[2 1 3]);
end
if do_flipud==1
    bg    =flipdim(bg,1);
    d     =flipdim(d,1);
    mask  =flipdim(mask,1);
end

%%label-cords
laco=zeros(size(c1,3),2);
for i=1:size(c1,3)
    [laco(i,1) laco(i,2)]=find(TX==i);
end



%%
% h=image(imfuse(bg,d,'blend'));
if sum(d(:))==0
    fus=bg;
else
    fus=bg.*.5+d.*.5;
end

% brightness=1.5;
% fus=fus*brightness;


% us.brightness=brightness;
us.fus=fus;
us.bg =bg;
us.ma =d;
us.mask=mask;

% ==============================================
%%   
% ===============================================


fg;
image(fus);
axis image; axis off;
title('bg-image & mask');
set(gcf,'userdata',us);

set(gca,'position',[0.05 0 1 1]); %axis normal;
hb=uicontrol('style','text','units','norm','string','bg-image & mask');
set(hb,'position',[0 0 1 .04],'foregroundcolor','b');


for i=1:size(c1,3)
    te(i)=text( laco(i,2)+size(c1,2)*0.5 ,laco(i,1), num2str(i));
    set(te(i),'color',[1.0000    0.8431         0],'tag','slicenum');
    set(te,'VerticalAlignment','top','fontsize',8,'fontweight','bold');
end
%     'baseline'
%     'top'
%     'cap'
%     'middle'
%     'bottom'
% ==============================================
%%   
% ===============================================


zoom on;
% fprintf('done\n');


hb=uicontrol('style','text','units','norm','string','Show');
set(hb,'position',[0 .9+1*.03 .1 .03],'fontsize',7,'backgroundcolor','w','HorizontalAlignment','left','fontweight','bold');

hb=uicontrol('style','radio','units','norm','string','both','value',1,'callback',@montage_post);
set(hb,'position',[0 .9 .15 .03],'fontsize',7,'backgroundcolor','w','userdata',1,'tag','rd_montage_ovl');
set(hb,'tooltipstring','show background image [BG] and mask');

hb=uicontrol('style','radio','units','norm','string','[0]BG,[1]Mask','value',0,'callback',@montage_post);
set(hb,'position',[0 .9-1*.03  .15 .03],'fontsize',7,'backgroundcolor','w','userdata',2,'tag','rd_montage_ovl');
set(hb,'tooltipstring','show background image [BG] or mask');


%slider-TXT
hb=uicontrol('style','text','units','norm','string','contrast');
set(hb,'position',[0 .8-0*.03  .15 .03],'fontsize',7,'backgroundcolor','w');
%slider-ui
hb=uicontrol('style','slider','units','norm','string','rb','value',0.5,'callback',@montage_slid_contrast);
set(hb,'position',[0 .8-1*.03  .15 .03],'fontsize',7,'backgroundcolor','w','userdata',[],'tag','montage_slid_contrast');
set(hb,'tooltipstring','change contrast');

% =========contour======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_contour','value',0);
set(hb,'position',[0 .7 .12 .04],'string','contour', 'callback',@montage_post);
set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
set(hb,'tooltipstring',['show contour' char(10) '-']);



montage_slid_contrast();
set(hw,'visible','off');


% hb=uicontrol('style','radio','units','norm','string','Mask','value',0,'callback',@montage_post);
% set(hb,'position',[0 .9-2*.03  .12 .03],'fontsize',7,'backgroundcolor','w','userdata',3,'tag','rd_montage_ovl');
function montage_slid_contrast(e,e2)
% uv=get(gcf,'userdata')
% hb=findobj(gcf,'tag','montage_slid_contrast');
% val=get(hb,'value');
% him=findobj(gca,'type','image');
% d=get(him,'cdata');
% set(him,'cdata',d.*(val*3));

hd=findobj(gcf,'tag','rd_montage_ovl');
hf=hd(find(cell2mat(get(hd,'value'))));
montage_post(hf,[]);

function montage_post(e,e2)
% 'a'
hd=findobj(gcf,'tag','rd_montage_ovl');
us=get(gcf,'userdata');
% get(e,'userdata')

hs=[findobj(hd,'userdata',1) findobj(hd,'userdata',2)];
rd=cell2mat(get(hs,'value'));
if  rd(1)==1 && rd(2)==0
    im=us.fus;%
elseif rd(1)==0 && rd(2)==1
    im=us.ma;
elseif rd(1)==0 && rd(2)==0
     im=us.bg;
elseif rd(1)==1 && rd(2)==1
    
    im=us.ma;
end
    
    


% return
% if get(e,'userdata')==2 % single img
%     set(findobj(hd,'userdata',1),'value',0); %other off
%     if get(e,'value')==1
%         im=us.ma;
%     else
%         im=us.bg; 
%     end
% else         %fuse
%     set(findobj(hd,'userdata',2),'value',0); %other off
%     if get(e,'value')==0
%         set(findobj(hd,'userdata',2),'value',0);
%         montage_post( findobj(hd,'userdata',2) ,[]);
%         return
%     else
%         im=us.fus;
%     end
%     
% end
% set(hd,'value',0);
% set(e,'value',1);
% val=get(e,'userdata');
% li={'fus','bg','ma'};
him=findobj(gca,'type','image');


hb=findobj(gcf,'tag','montage_slid_contrast');
val=get(hb,'value');
if get(e,'userdata')==1
    im2=im*val*2;
else
    im2=im*val*2;
end
set(him,'cdata',im2);

% ----contour
hold on;
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
uni=unique(us.mask); uni(uni==0)=[];



docontour=get(findobj(gcf,'tag','montage_contour'),'value');
if docontour==1
%     %覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
     delete(findobj(gca,'type','contour'));
    hold on;contour(us.mask,length(uni),'linewidth',2);
    colormap(u.colmat(uni,:));
    %colorbar
    %caxis([0 size(u.colmat,1)]);
    caxis([1 max(uni)]);
    
% %     fg
%     col = u.colmat(uni,:) ;%[1 0 0;0 1 0;0 0 1]
%     set(gca,'nextplot','replacechildren')
%     set(gca,'colororder',col)
%     contour(us.mask,'-')
%     
%     
%     fg
%     [C,h]=contour(peaks);
%     clabel(C,h)
%     set(findobj(gca,'Type','patch','UserData',2),'EdgeColor',[0 0 0])
    
    %覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
else
    delete(findobj(gca,'type','contour'));
end

% ==============================================
%%   
% ===============================================


function set_idlist()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
ids=unique(u.b(:)); ids(isnan(ids))=[]; ids(ids==0)=[];
val=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
ids=unique([ids; val]);
sel=find(ids==val);
idlist=cellfun(@(a){[num2str(a)]} ,num2cell(ids) );
hlist=findobj(gcf,'tag','pb_idlist');
% set(hlist,'string',{'<HTML><FONT color=#0000FF><b>Red</FONT></HTML>'},'value',sel);
% '<HTML><FONT color="red">Red</FONT></HTML>'
list={};
for i=1:length(ids)
    colrgb=u.colmat(ids(i),:);
    col=reshape(dec2hex(round(colrgb*255), 2)',1, 6);
    list(end+1,1)={['<HTML><FONT color=#' col  '><b>' num2str(ids(i)) '</FONT></HTML>']};
end
set(hlist,'string',list,'value',sel);
set(hlist,'backgroundcolor',[.8 .8 .8]);
set(hlist,'userdata',ids);


function pb_idlist(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hb=findobj(hf1,'tag','edvalue');
hlist=findobj(hf1,'tag','pb_idlist');
ids=get(hlist,'userdata');
%  list=get(hlist,'string');
va=get(hlist,'value');
%  id=str2num(list{va});
id=ids(va);

set(hb,'string',num2str(id));
%  reshape(dec2hex([1 1 1]*255, 2)',1, 6)
axes(findobj(gcf,'Type','axes'));
edvalue();

set(gco,'enable','off'); % to allow keyboard outside listbox
drawnow; pause(.1);
set(gco,'enable','on');
axes(findobj(gcf,'Type','axes'));

function edvalue(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hb=findobj(hf1,'tag','edvalue');
num=str2num(get(hb,'string'));
try
    set(hb,'BackgroundColor',u.colmat(num,:));
catch
    warndlg([...
        ['You want to use ID=' num2str(num) ' which refers to the ' num2str(num) 'th. color.' char(10)]...
        ['BUT: Currently only ' num2str(size(u.colmat,1)) ' colors defined.' char(10)] ...
        ['Solution: Increase number of colors ("numColors") via configuration ' char(10)],...
        ],'INCREASE number of colors');
    
    set(hb,'string','1'); drawnow;
    uiwait(gcf);
    edvalue([],[]);
    return
end

hdot=findobj(hf1,'tag','dot');
set(hdot,'FaceColor',u.colmat(num,:));
set_idlist();
axes(findobj(gcf,'Type','axes'));


function  x=transpoflip(x,dirs)
% transpose and flipud check
hf1=findobj(0,'tag','xpainter');

if strcmp(dirs,'f') %forward
    %% transpose
    htran=findobj(hf1,'tag','rd_transpose');
    doTrans=get(htran,'value');
    if doTrans==1
        x=permute(x, [2 1 3]);
    end
    %% flipud
    hflip=findobj(hf1,'tag','rd_flipud');
    if get(hflip,'value')==1
        x=flipud(x);
    end
elseif strcmp(dirs,'b'); %back
    %% flipud
    hflip=findobj(hf1,'tag','rd_flipud');
    if get(hflip,'value')==1
        x=flipud(x);
    end
    %% transpose
    htran=findobj(hf1,'tag','rd_transpose');
    doTrans=get(htran,'value');
    if doTrans==1
        x=permute(x, [2 1 3]);
    end
    
end






function cb_fill(e,e2)
set(gcf,'WindowButtonMotionFcn', []);
hl=findobj(gcf,'tag','undo'); %set togglebut to painting
if get(hl,'value')==1; set(hl,'value',0); end

% va=get(e,'value');
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');


r1=getslice2d(u.b);

r1=transpoflip(r1,'f');

bk=r1;

[x y]=ginput(1);

selstop([],[]);
selstop([],[]);
selstop([],[]);

hed=findobj(hf1,'tag','edvalue');
id=str2num(get(hed,'string'))
r1=r1==id;

sm=strel('disk',1);
%  r2=imerode( imdilate( r1  ,sm)  ,sm);
r2=imclose( r1  ,sm) ;
warning off;
r3=imfill(im2bw(r2),[round(y) round(x) ],8);
r4=bwlabel(r3);
clustnum=r4(round(y), round(x));
val=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
r5=bk;
r5(r4==clustnum)=val;

r5=transpoflip(r5,'b');
u=putsliceinto3d(u,r5,'b');
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn', {@motion,1});
setslice([],'moox');



function cb_clear(e,e2)
va=get(e,'value');
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
% him=findobj(hf1,'type','image');
r2=getslice2d(u.b)*0;
% set(him,'cdata',   r2  );
u=putsliceinto3d(u,r2,'b');
set(gcf,'userdata',u);


if va==2
    u.b=u.b.*0;
    set(gcf,'userdata',u);
end

setslice();

function pb_help(e,e2)
uhelp(mfilename);


function pb_save(e,e2)
hf=findobj(0,'tag','xpainter');

u=get(hf,'userdata');
[fi pa]=uiputfile(fullfile(fileparts(u.f1),'*.nii'),'save new mask as..');
if isnumeric(fi);
    return;
end

if max(unique(u.b))<=255
    dt=[2 0];
else
    dt=[16 0];
end
so=findobj(hf,'tag','pb_saveoptions');
li=get(so,'string'); va=get(so,'value');
% ==============================================
%%   saveoption
% ===============================================

saveop=li{va};
if ~isempty(regexpi(saveop,'\[sm\]'))
    %     11
    c=u.b;
elseif ~isempty(regexpi(saveop,'\[smi00\]'))
    %     22
    m=u.b>0;
    c=u.a.*m;
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi0m\]'))
    %     33
    m=u.b>0;
    c=u.a.*m+(m==0).*mean(u.a(:));
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi10\]'))
    %     44
    m=~(u.b>0);
    c=u.a.*m;
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi1m\]'))
    % 55
    m=~(u.b>0);
    val=mean(u.a(m==1));
    
    if isnan(val); 
        warndlg({'no mask found' '..saving step aborted..'});
        return
    end
    c=u.a.*m+(m==0).*val;
    dt=u.ha.dt;
else ~isempty(regexpi(saveop,'\[smi1nv\]')) || ~isempty(regexpi(saveop,'\[smi0nv\]'))
    m=double(~(u.b>0));
    if ~isempty(regexpi(saveop,'\[smi0nv\]'))
        m=~m;
    else
    for i=1:size(m,3)
        m(:,:,i)=imfill(m(:,:,i),'holes');
        m(:,:,i)=imerode(m(:,:,i),strel('disk',2));
    end
    end
    m(m==0)=nan;
    as=u.a.*m;
    af=snip_inpaintn(as,10);
    %montage2(af); title('fil')
    
    c=af;
    dt=u.ha.dt;
end

% montage2(c);

% [smi00]
% [smi0m]
%  [smi10]
% [smi1m]

% ==============================================
% save
% ===============================================
newmask=fullfile(pa,fi);
% rsavenii(newmask,u.hb,c,dt);
rsavenii(newmask,u.ha,c);

try
    showinfo2('new mask',u.f1,newmask,13);
end





function pb_legend(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(gcf,'userdata');
uni=unique(u.b(:)); uni(uni==0)=[];
nvox=histc(u.b(:),uni);
vol=abs(det(u.ha.mat(1:3,1:3)) *(nvox));
hold on;
if isempty(uni)
    pl(1) = plot(nan,nan,'ko','markerfacecolor',[1 0 1]);
    lgstr={'there is nothing drawn in mask'};
else
    lgstr={};
    for i=1:length(uni)
        pl(i) = plot(nan,nan,'ko','markerfacecolor',u.colmat(uni(i),:));
        lgstr{end+1} = sprintf('%d] \t#%d voxel,\t %5.3f qmm\t', uni(i),nvox(i),vol(i));
    end
%     lgstr=cellstr([num2str(uni) ]);
end

le=legend(pl,lgstr,'fontsize',5);
set(le,'Location','northeast','tag','xlegend');
% pos=get(le,'position');
% pos(3)=pos(3)/5;
% set(le,'position',pos);
% set(le,'Color','none','TextColor',[ 0.9294    0.6941    0.1255],'fontweight','bold');
set(le,'Color','k','TextColor',[ 0.9294    0.6941    0.1255],'fontweight','bold');
if get(findobj(gcf,'tag','pb_legend'),'value')==0
    try; delete(findobj(gcf,'tag','xlegend')); end
end

% ==============================================
%%   
% ===============================================
function pb_slicewiseInfo(e,e2)
% ==============================================
%%   
% ===============================================

hf1=findobj(0,'tag','xpainter');
u=get(gcf,'userdata');
uni=unique(u.b(:)); uni(uni==0)=[];
nvox=histc(u.b(:),uni);
vol=abs(det(u.ha.mat(1:3,1:3)) *(nvox));
hold on;
if isempty(uni)
    lgstr={'there is nothing drawn in mask'};
else
    lgstr={};
    for i=1:length(uni)
        lgstr{end+1,1} = sprintf('ID: %3d] \t#%5d voxel,\t %5.3f qmm\t', uni(i),nvox(i),vol(i));
    end
%     lgstr=cellstr([num2str(uni) ]);
end
hb=findobj(hf1,'tag','rd_changedim');
dimlist=get(hb,'string');
dimval=get(hb,'value');
dim=str2num(dimlist{dimval});


c=u.b;
c=permute(c,[setdiff([1:3],dim)  dim]);
c=reshape(c,[ size(c,1)*size(c,2) size(c,3)]);
siv=abs(det(u.ha.mat(1:3,1:3)));
% ==============================================
% 
% ===============================================

g1={};

sortid=[];
for j=1:size(c,2)
    nvox2 =histc(c(:,j),uni);
    vol2  =siv*nvox2;
    
    for i=1:length(uni)
        if nvox2(i)>0
            g1{end+1,1} = sprintf('slice-%2d  ID-%3d] \t#%5d voxel   \t\t\t %5.3f qmm\t',j, uni(i),nvox2(i),vol2(i));
            sortid(end+1,1)=uni(i);
        end
    end
end
% disp(g1)


z={};
z{end+1,1}=[' #ok *** global info ***'];
z{end+1,1}=       [' #b File      : '  u.f1];          
z{end+1,1}=sprintf('        DIM: %dx%dx%d', u.ha.dim(1),u.ha.dim(2),u.ha.dim(3));
voxmm=abs(diag(u.ha.mat(1:3,1:3)));
z{end+1,1}=sprintf('VoxSize[mm]: %2.3f   %2.3f   %2.3f   ', voxmm(1),voxmm(2),voxmm(3));
z{end+1,1}='';

z{end+1,1}=[' #ld *** IDs within entire volume (MASK) ***'];
z=[z; lgstr ];
z{end+1,1}='';

if ~isempty(g1)
    g2= sortrows([num2cell(sortid) g1],1) ;%sorted by ID
    g2=g2(:,2);
    z{end+1,1}=[' #ld *** IDs slice-wise info (MASK) ***'];
    z{end+1,1}=[' #b used DIM   : '  num2str(dim)];
    z=[z; g2 ];
end
uhelp(z);

% ==============================================
%%   
% ===============================================



% ==============================================
%%   
% ===============================================


function pop_changedim(e,e2)


e=findobj(gcf,'tag','rd_changedim');
li=get(e,'string');
va=get(e,'value');
newdim=str2num(li{va});
u=get(gcf,'userdata');
u.usedim=newdim;
u.useslice=round(u.dim(u.usedim)/2);
set(gcf,'userdata',u);
set(findobj(gcf,'tag','edslice'),'string',num2str(u.useslice));
setslice();

function rd_dottype(e,e2)
definedot([],[]);

function edalpha(e,e2,par)
u=get(gcf,'userdata');
u.alpha=str2num(get(e,'string'));
set(gcf,'userdata',u);
set(e,'string',num2str(u.alpha));
setslice();


function cb_setslice(e,e2,par)
u=get(gcf,'userdata');
if strcmp(par,'-1')
    
    if u.useslice>1
        u.useslice=u.useslice-1;
    end
elseif strcmp(par,'+1')
    if u.useslice<u.dim(u.usedim)
        u.useslice=u.useslice+1;
    end
elseif strcmp(par,'ed')
    sl=str2num(get(findobj(gcf,'tag'  ,'edslice'),'string'));
    if sl>0 && sl<=u.dim(u.usedim)
        u.useslice=sl;
    end
end
set(gcf,'userdata',u);
setslice();








function selup(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
set(hd,'edgecolor','k');
'w'

function selectarea(e,e2)
set(gcf,'WindowButtonMotionFcn', {@motion,1})
% set( findobj(gcf,'tag','selectarea') ,'backgroundcolor',[ 1.0000    0.8431         0]);
% set( findobj(gcf,'tag','undo') ,'backgroundcolor',[ 1 1 1]);

function undo(e,e2)
e=findobj(gcf,'tag','undo');
if get(e,'value')==1 % UNPAINT
    set(gcf,'WindowButtonMotionFcn', {@motion,2});
    set(e,'backgroundcolor',[1.0000    0.8431         0]);
    % set( findobj(gcf,'tag','undo') ,'backgroundcolor',[ 1.0000    0.8431         0]);
    % set( findobj(gcf,'tag','selectarea') ,'backgroundcolor',[ 1 1 1]);
else           %DRAW
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    set(e,'backgroundcolor',[.94 .94 .94]);
end
% ==============================================
%%
% ===============================================

function definedot(e,e2)
hf1=findobj(0,'tag','xpainter');
hc=findobj(hf1,'tag','dotsize');
va=get(hc,'value');
li=get(hc,'string');
dia=str2num(li{va});

hdot=findobj(hf1,'tag','dot');
if isempty(hdot)
    colix=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
    u=get(gcf,'userdata');
    col=u.colmat(colix,:);
else
    try
        col=get(hdot,'facecolor');
    catch
        col=get(hdot(1),'facecolor');
    end
end


try; delete(findobj(hf1,'tag','dot')); end
r=dia/2;
th = 0:pi/50:2*pi;
x = r * cos(th) ;
y = r * sin(th) ;
z = x*0;

if get(findobj(hf1,'tag','rd_dottype'),'value')==2;
    x=[-r r r -r];     y=[-r -r r r];
    z=x*0;
elseif get(findobj(hf1,'tag','rd_dottype'),'value')==3;
    x=[-r r r -r];    y=[1 1 2 2];
    z=x*0;
elseif get(findobj(hf1,'tag','rd_dottype'),'value')==4;
    x=[1 2 2 1];  y=[ -r -r r r];
    z=x*0;
end
co=get(gca,'CurrentPoint');
co=co(1,[1 2]);
x=x+co(1);
y=y+co(2);

hd = patch(x,y,z,'g','tag','dot');
set(hd,'facecolor',col);
set(hd  ,'ButtonDownFcn', @sel);
set(hd,'userdata',0);

u=get(hf1,'userdata');
u.dotsize=dia;
set(hf1,'userdata',u);


function buttondown(e,e2,par)
% '##'


% ==============================================
%% Button down
% ===============================================
function sel(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
col=u.colmat(str2num(get(findobj(hf1,'tag','edvalue'),'string')),:);
hd=findobj(hf1,'tag','dot');
set(hd,'FaceColor',col,'edgecolor','k');
set(hd,'userdata',1);
if get(findobj(gcf,'tag','undo'),'value')==0   %PAINT -BTN-DOWN
   % '#1start'
    getImage();  %######
    set(hd,'FaceColor',col,'edgecolor','w');
    motion([],[], 1);
   % '#1end'
else                                          %UNPAINT-BTN-DOWN
  % '#2start'
   getImage();   %######
    set(hd,'FaceColor',col,'edgecolor','g');
    motion([],[], 2);
   % '#2end'
end
% ==============================================
%% Button up
% ===============================================
function selstop(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

ismeasure=get(findobj(hf1,'tag','pb_measureDistance'),'value');
if ismeasure==1; return; end

putImage(); %######

col=u.colmat(str2num(get(findobj(hf1,'tag','edvalue'),'string')),:);
hd=findobj(gcf,'tag','dot');
set(hd,'FaceColor',col,'edgecolor','k');
set(hd,'userdata',0);

u=get(gcf,'userdata');
xylim=[xlim ylim];
co=get(gca,'currentpoint');
if co(1,1)<xylim(2) && co(1,2)>0
    %disp('inIMAGE')
    %---make history
    r2=getslice2d(u.b);
    u.histpointer=u.histpointer+1;
    u.hist(:,:,u.histpointer)=r2;
    set(gcf,'userdata',u);
end

% ==============================================
%%  button-DOWN: put current image to u-struct for drawing
% ===============================================
function getImage()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

r1=getslice2d(u.a);
r2=getslice2d(u.b);
r1=adjustIntensity(r1);
% u.r1=r1;
% u.r2=r2;
% set(hf1,'userdata',u);

global SLICE
SLICE.r1=r1;
SLICE.r2=r2;

% ==============================================
%%  button-UP: put current image to 3d-mask
% ===============================================
function putImage();
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
% r2n=u.r2;
% u=putsliceinto3d(u,r2n,'b');
% set(hf1,'userdata',u);

global SLICE
try
if isempty(SLICE.r2)
   keyboard 
end
r2n=SLICE.r2;
u=putsliceinto3d(u,r2n,'b');
set(hf1,'userdata',u);
catch
   return 
end

% ==============================================
%% MOTION
% ===============================================
function motion(e,e2, type)
hf1=findobj(0,'tag','xpainter');
ismeasure=get(findobj(hf1,'tag','pb_measureDistance'),'value');
if ismeasure==1; return; end

% 'ri'


u=get(hf1,'userdata');
hax=findobj(hf1,'type','axes');
co=get(hax,'CurrentPoint');
try
    co=co(1,[1 2]);
catch
    return
end
axlim=[get(hax,'xlim') get(hax,'ylim')];
showDot=0;
% set(gcf,'pointer','arrow');
if co(1)<1 || co(2)<1 || co(1)>axlim(2)  %1 | co(2)<1
    set(hf1,'Pointer','arrow');
    %'yes'
else
    %vp=nan(16,16);
     showDot=1;
    set(hf1, 'Pointer', 'custom', 'PointerShapeCData', NaN(16,16)); 
    %'no'
end

% --------over object
% hAxes = overobj('axes');
% disp(hAxes);
hunderpointer=hittest(hf1);
% disp(get(hunderpointer,'tag'));
if strcmp(get(hunderpointer,'type'),'image')~=1 && strcmp(get(hunderpointer,'tag'),'dot')~=1
    % disp(get(hunderpointer,'style'));
    % disp(get(hunderpointer,'type'));
    showDot=0;
    set(hf1,'Pointer','hand');
end
% if ~isempty(hAxes)
%     set(gcf,'Pointer','fleur');
% %     'w'
% else
%     set(gcf,'Pointer','hand');
% %     'i'
% end

% -----------------
% if strcmp(get(gco,'tag'),'xpainter')==0 % not focus
%     set(hf1,'Pointer','arrow');
% else
%     
% 
%     
%     
% end

hd=findobj(hf1,'tag','dot');
xx=get(hd,'XData');
yy=get(hd,'yData');
xs=(xx-mean(xx))+2;
ys=(yy-mean(yy))+2;
x=xs+co(1);
y=ys+co(2);

set(hd,'xdata',x,'ydata',y);

if get(hd,'userdata')==1  %PAINT NOW ---button down
    u=get(hf1,'userdata');
    x2=get(hd,'XData'); % get POINTS of coursor/dot
    y2=get(hd,'yData');
%      disp(rand(1)); return
    dims = u.dim(setdiff(1:3,u.usedim));
    if get(findobj(hf1,'tag','rd_transpose'),'value')==1
        bw   = double(poly2mask(x2,y2,dims(2),dims(1)));
    else
        bw   = double(poly2mask(x2,y2,dims(1),dims(2)));
    end
    seltype=get(gcf,'SelectionType');
    if strcmp(seltype,'open') || strcmp(seltype,'alt')
        bw=bw.*0;
    end

   %% type: drfines whether to paint/unpaint
    if type~=0 %PAINT 
        
        global SLICE
        r1=SLICE.r1;
        r2=SLICE.r2;
%         r1=u.r1;
%         r2=u.r2;
        if 0 % OUTSOURCED
            r1=getslice2d(u.a);
            r2=getslice2d(u.b);
        end
        % ----------------------------------------------------
        %% transpose
        if get(findobj(hf1,'tag','rd_transpose'),'value')==1
            %x=permute(r2, [2 1 3]);
            r1=r1';
            r2=r2';
        end
        if get(findobj(hf1,'tag','rd_flipud'),'value')==1
            r1=flipud(r1);
            r2=flipud(r2);
        end
        % ----------------------------------------------------
        si=size(r2);
        r2=r2(:);
        if type==1
            r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
        elseif type==2
            r2(bw==1)  =  0;
        end   
        %---------------
        r2=reshape(r2,si);
        %% ==============================================
        %%  double click --> fill
        % ===============================================
        seltype=get(gcf,'SelectionType');
        if strcmp(seltype,'open') || strcmp(seltype,'alt')
            %disp(['now-' num2str(rand(1))]);
            value=str2num(get(findobj(hf1,'tag','edvalue'),'string')); 
            value=r2(round(co(2)),round(co(1))  );
            m1=r2==value;
            r2(m1==1)=0;
            x2=mean(x); y2=mean(y);
            sm=strel('disk',1);
            %  r2=imerode( imdilate( r1  ,sm)  ,sm);
            m2=imclose( m1  ,sm) ;
            warning off;
            m3=imfill(m2,'holes');
            m4=bwlabel(m3);
            try
            clustnum=m4(round(y2), round(x2));
            catch
               return 
            end
            m5=m1;
            if strcmp(seltype,'open')
                m5(m4==clustnum)=1;
                r2(m5==1)=value;
            elseif strcmp(seltype,'alt')
                m5(m4==clustnum)=0;
                r2(m5==1)=value;
            end
        end
        
        % ==============================================
        %% set value
        % ===============================================
        alp=u.alpha;% .8
        %val=unique(u.b); val(val==0)=[];
        val=get(findobj(hf1,'tag','pb_idlist'),'userdata');
        
        r2v=r2(:);
        r1=mat2gray(r1);
        ra=repmat(r1,[1 1 3]);
        rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
        for i=1:length(val)
            ix=find(r2v==val(i));
            rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
        end
        s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
        rm=sum(rb,2);
        im=find(rm~=0);
        %s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
        s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
        x=reshape(s1,size(ra));
        set(u.him,'cdata',   x  );
   
        r2n=r2;
        if get(findobj(hf1,'tag','rd_flipud'),'value')==1
            r2n=flipud(r2n);
        end
        if get(findobj(hf1,'tag','rd_transpose'),'value')==1
            r2n=r2n';
        end
        % ==============================================
        %%   %% outsource
        % ===============================================
        %u.r2=r2n;
        global SLICE
        SLICE.r2=r2n;
%         if 0
%             u=putsliceinto3d(u,r2n,'b');
%             set(hf1,'userdata',u);
%         end
    end  %type
end



function u=putsliceinto3d(u,d2,varnarname)
% u=putsliceinto3d(u,r2,'b');
dum=getfield(u,varnarname);
% try
    if u.usedim==1
        dum(u.useslice,:,:)=d2;
    elseif u.usedim==2
        dum(:,u.useslice,:)=d2;
    elseif u.usedim==3
        dum(:,:,u.useslice)=d2;
    end
    u=setfield(u,varnarname,dum);
% end

function imtoolbreak
hf1=findobj(0,'tag','xpainter');
allbut=findobj(hf1,'userdata','imtoolsbutton');
set(allbut,'value',0);

import java.awt.*;
import java.awt.event.*;
rob = java.awt.Robot;
rob.keyPress(KeyEvent.VK_ESCAPE)
pause(.1);
rob.keyRelease(KeyEvent.VK_ESCAPE)

set(gcf,'WindowButtonMotionFcn', {@motion,1});
delete(findobj(hf1,'userdata','imtool'));
disp('imtool break');
delete(findobj(hf1,'userdata','imtool'));

%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
function  imdrawtool_prep(e,e2,type)

hf1=findobj(0,'tag','xpainter');
allbut=findobj(hf1,'userdata','imtoolsbutton');
otherbut=setdiff(allbut,e);
set(otherbut,'value',0); % all other icons set 'OFF'
%  imtoolbreak();
 
if get(e,'value')==0
    imtoolbreak();
    set(allbut,'enable','on');
else
    set(otherbut,'enable','off');
    set(gcf,'WindowButtonMotionFcn',[]);
    imdrawtool(e,e2, type);
end
set(allbut,'value',0); % all other icons set 'OFF'
set(allbut,'enable','on');
% set(gcf,'WindowButtonMotionFcn', {@motion,1});

hb=findobj(hf1,'tag','undo');
hgfeval(get( hb ,'callback'));

axes(findobj(gcf,'Type','axes'));
uicontrol(findobj(hf1,'tag','preview')); %set focus to allow brush-resize

return
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
if isfield(u,'activetool')==0
    u.activetool=type;
    set(hf1,'userdata',u);
end

if u.activetool==type
  try
      imdrawtool(e,e2, type);
  end
else
    'no'
    allbut=findobj(hf1,'userdata','imtoolsbutton');
    iactive=find(cell2mat(get(allbut,'value')));
    nother=setdiff(allbut,e);
    for i=1:length(iactive)
        typeold=getappdata(allbut(iactive(i)),'toolnr');
        set(allbut(iactive(i)),'value',0);
         imdrawtool(e,e2, typeold);
%          return
         %hgfeval(get( allbut(iactive(i)) ,'callback'),[],[],typeold);
    end
    if length(nother)==0
       '## no acitve butos' 
    else
        '## some active found'
    end
    set(allbut,'value',0);
    
    import java.awt.*;
    import java.awt.event.*;
    rob = java.awt.Robot;
    rob.keyPress(KeyEvent.VK_ESCAPE)
    pause(.1);
    rob.keyRelease(KeyEvent.VK_ESCAPE)
    
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    delete(findobj(hf1,'userdata','imtool'));
    disp('imtool-off');
    %------------------
    set(e,'value',1);
    u.activetool=type;
    set(hf1,'userdata',u);
    
    %     imdrawtool(e,e2, type);
    
    if length(nother)==0
        '## no acitve butos'
    else
        '## some active found'
         try; 
         
             set(e,'value',0)
%              hgfeval(get( e ,'callback'),e);
           imdrawtool(e,e2, type);      
         end  
    end
end

% ==============================================
%%
% ===============================================
function imdrawtool(e,e2, type)
if get(e,'value')==0
    return
end

hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
% hb=findobj(hf1,'tag','imdraw');
hb=e;
allbut=findobj(hf1,'userdata','imtoolsbutton');
set(setdiff(allbut,e),'value',0); % all other icons set 'OFF'
activeButton=get(hb,'value');
if activeButton==0 %get(hb,'value')==0
    try
        uiresume(hf1);
    end
    import java.awt.*;
    import java.awt.event.*;
    %Create a Robot-object to do the key-pressing
    %    rob=Robot;
    rob = java.awt.Robot;
    %Commands for pressing keys:

    rob.keyPress(KeyEvent.VK_ESCAPE)
    pause(.1);
    rob.keyRelease(KeyEvent.VK_ESCAPE)
    
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    delete(findobj(hf1,'userdata','imtool'));
%     disp('imtool-off');
    return
    % break
end

do_unpaint=get(findobj(hf1,'tag','undo'),'value');
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hax=findobj(gcf,'type','axes');

% findobj(hf1,'userdata','imtoolsbutton')
% imellipse | imfreehand | imline | impoint | impoly | imroi | makeConstrainToRectFcn
    
    set(gcf,'WindowButtonUpFcn'     ,[]);
    if type==1
        try; h = imfreehand;
            %     catch; imdrawtool(e,e2, type);
        end
    elseif type==2
        try; h=imrect;
            %     catch; imdrawtool(e,e2, type);
        end
    elseif type==3
        try; h=imellipse;
            %     catch; imdrawtool(e,e2, type);
        end
    elseif type==4
        try; h=impoly;
            %     catch; imdrawtool(e,e2, type);
        end
    elseif type==5
        try; h=imline;
            %     catch; imdrawtool(e,e2, type);
        end
    end
    set(gcf,'WindowButtonUpFcn'     ,@selstop);
    % uiwait(hf1);
    % setappdata(h,'imrecttools',1);
    try
        set(h,'userdata','imtool');
        try
        u.handleroi=h;
        set(hf1,'userdata',u);
        end
    catch
        set(gcf,'WindowButtonMotionFcn', {@motion,1});
        try; delete(h); end
        delete(findobj(hf1,'userdata','imtool'));
        return
    end
    pos = h.getPosition();
    y2=pos(:,2);
    x2=pos(:,1);
    
dims = u.dim(setdiff(1:3,u.usedim));
bw=createMask(h);
xm=round(mean(x2));
ym=round(mean(y2));
activeIcons_show();
uiwait(hf1); %wait for activeIcons.selection
u=get(hf1,'userdata');
delete(h);
if u.activeIcons_do==4 %cancel
%     imdrawtool(e,e2, type);
    return
elseif u.activeIcons_do==2 %boundary/ege
   % bw=boundarymask(bw);
    bw=bwperim(bw);
end

r1=getslice2d(u.a);
r2=getslice2d(u.b);
r1=adjustIntensity(r1);

% global SLICE
%         r1=SLICE.r1;
%         r2=SLICE.r2;

% ----------------------------------------------------
%% transpose
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end
% ----------------------------------------------------
si=size(r2);
r2=r2(:);
% if type==1
%     r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
% elseif type==2
%     r2(bw==1)  =  0;
% end
  r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
r2=reshape(r2,si);

% ==============================================
%%
% ===============================================
value=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
if u.activeIcons_do==3 %UNPAINT
    r2=r2.*~bw; %UNPAINT
end
alp=u.alpha;% .8
% alp =u.create_distanceMeas;% .8
val=unique(u.b);
val=[val(:) ;value];
val(val==0)=[];
val=unique(val);
r2v=r2(:);
r1=mat2gray(r1);
ra=repmat(r1,[1 1 3]);

rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
rm=sum(rb,2);
im=find(rm~=0);
% s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
x=reshape(s1,size(ra));
set(u.him,'cdata',   x  );
r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end
% ==============================================
%%   %% outsource
% ===============================================
%u.r2=r2n;
global SLICE
SLICE.r2=r2n;

if 1
    u=putsliceinto3d(u,r2n,'b');
    
    % ----history
    u.histpointer=u.histpointer+1;
    u.hist(:,:,u.histpointer)=r2n;
end
% ------------
set(hf1,'userdata',u);
%----------------
delete(h);
% if get(e,'value')==1
% %     imdrawtool_prep(e,e2, type);
% end


function activeIcons_hover(e,e2,par)
hf1=findobj(0,'tag','xpainter');
tag=get(e,'Name');
hc=findobj(hf1,'tag',tag);
hc=hc(1);
if par==1
    set(hc,'backgroundcolor',[1 1 0]);
    set(gcf,'WindowButtonMotionFcn', []);
    set(gcf,'pointer','arrow');
    drawnow;
    lineColor = java.awt.Color(0,.5,0);  % =red
    thickness = 3;  % pixels
    roundedCorners = false;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    e.setBorder(newBorder);
    drawnow;
else
    set(hc,'backgroundcolor',[1 1 1]);
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    drawnow;
    lineColor = java.awt.Color(1,0,1);  % =red
    thickness = 3;  % pixels
    roundedCorners = false;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    e.setBorder(newBorder);
    drawnow;
end


function activeIcons_show();
hf1=findobj(0,'tag','xpainter');
po=get(gcf,'CurrentPoint');
delete(findobj(hf1,'userdata','activeIcons'));
boxsi=0.04;

hc2=[];
po=get(gcf,'CurrentPoint');
hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_fill');           %SET-next-SLICE
set(hc,'position',[po(1) po(2)+.01 repmat(boxsi,[1 2]) ],'string','f');
set(hc,'tooltipstring','fill region');
hc2(end+1)=hc;

hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_edge');           %SET-next-SLICE
set(hc,'position',[po(1)+boxsi po(2)+.01 repmat(boxsi,[1 2]) ],'string','e');
set(hc,'tooltipstring','edge rigion/draw boundary only ...do not fill');
hc2(end+1)=hc;

hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_del');           %SET-next-SLICE
set(hc,'position',[po(1)+boxsi*2 po(2)+.01 repmat(boxsi,[1 2]) ],'string','u');
set(hc,'tooltipstring','unpaint rigion');
hc2(end+1)=hc;

hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_break');           %SET-next-SLICE
set(hc,'position',[po(1)+boxsi*3 po(2)+.01 repmat(boxsi,[1 2]) ],'string','x');
set(hc,'tooltipstring','abort...do nothing');
hc2(end+1)=hc;

for i=1:length(hc2)
    hc=hc2(i);
    g=java(findjobj(hc));
    set(g,'MouseEnteredCallback',{@activeIcons_hover,1});
    set(g,'MouseExitedCallback',{@activeIcons_hover,2});
    set(hc,'userdata','activeIcons');
    set(hc,'callback',{@activeIcons_cb,i});
    
    lineColor = java.awt.Color(1,0,1);  % =red
    thickness = 3;  % pixels
    roundedCorners = false;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    g.setBorder(newBorder);
    
end

function activeIcons_cb(e,e2,par)
% par
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
u.activeIcons_do=par;
set(hf1,'userdata',u);
delete(findobj(hf1,'userdata','activeIcons'));
uiresume(hf1);

%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
%%   DISTANCE-TOOL
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
function create_distanceMeas
%create_distanceMeas - Show use of FINDOBJ and TAG property to identify active handle
%during addNewPositionCallback
% Created for R2007b

% close all
% clear all
if 0
    cf
    fg
    I = imread('pout.tif');
    
    imshow(I);
end
% [ha a]=rgetnii('AVGT.nii');
% 
% fg
% dim=2
% a2=dqueeze
% imagesc()




h1 = imdistline;
set(h1,'Tag','distline1');
api1 = iptgetapi(h1);


u=get(gcf,'userdata');
u.meas.h1=h1;
u.meas.api=api1;
set(gcf,'userdata',u);

% h2 = imdistline;
% set(h2,'Tag','distline2');
% api2 = iptgetapi(h2);

id1 = api1.addNewPositionCallback(@(x) cb_distanceMeas(h1,x,1));
% id2 = api2.addNewPositionCallback(@(x) cb_distanceMeas(x,2));
h1.setColor([1 0 0]);
u=get(gcf,'userdata');

hb=uicontrol('style','pushbutton','units','norm','string','x','tag','pb_deldistfun',...
    'callback',{@pb_deldistfun,api1},'tooltipstring','close distance measuring tool');

cb_distanceMeas(h1,[],1);
updateDeldistBtn(1);

function updateDeldistBtn(par)
hd=findobj(gcf,'tag','end point 1');
hb=findobj(gcf,'tag','pb_deldistfun');

x=get(hd,'xdata');
y=get(hd,'ydata');
if par==1 %start
    ax = gca;
    AxesPos = get(ax, 'position');
    xscale = get(ax, 'xlim' );
    yscale = get(ax, 'ylim');
    x2=(x-xscale(1))/(xscale(2)-xscale(1))*AxesPos(3)+AxesPos(1);
    y2=1-(y-yscale(1))/(yscale(2)-yscale(1))*AxesPos(4)+AxesPos(2);
    set(hb,'position',[x2 y2 .1 .1]);
else
    co=get(gcf,'CurrentPoint');
    set(hb,'position',[co(1)-0.01 co(2) .1 .1]);
end
    

% hb=uicontrol('style','pushbutton','units','norm','string','x');

% hd=findobj(h1,'tag','end point 1')
% 

set(hb,'units','pixels');
pos=get(hb,'position');
si=14;
set(hb,'position',[pos(1)-si*1.5 pos(2)+0 si si]);
set(hb,'units','norm');


%   Text    (distance label)
%   Line    (end point 2)
%   Line    (end point 1)
%   Line    (top line)
%   Line    (bottom line)

function cb_distanceMeas(h1,pos,id)

updateDeldistBtn(0);
% disp(id);
h = findobj(gcf,'Tag',['distline' num2str(id)]) ;
% disp(get(h,'Tag'));
% disp(pos);

dis=h1.getDistance();
ang=h1.getAngleFromHorizontal();

hl=findobj(h,'tag','distance label');
% set(hl,'string',{['s: '  sprintf('%2.3f',dis) 'mm']
%     ['s: '  sprintf('%2.3f',dis) 'pix']
%     ['{\theta}: '  sprintf('%2.3f',ang) 'ｰ']},'fontsize',8);

% 'a'
tpos=get(hl,'position');
% disp(ang);
% if ang>90 && ang<=170
%     set(hl,'position',[tpos(1)+16 tpos(2)-16 tpos(3)])
% elseif  ang>170 && ang<=180
%     set(hl,'position',[tpos(1)+16 tpos(2)-16*2 tpos(3)])  
% elseif  ang>=0 && ang<=90
%     set(hl,'position',[tpos(1)+16 tpos(2)-16*2 tpos(3)])
% end

tmtag=get(gco,'tag');
if isempty(tmtag)
    tmtag='end point 1';
end
if sum(strcmp(tmtag,{'end point 1', 'end point 2'}))==0
    tmtag='end point 1';
end


tm=findobj(h1,'tag',tmtag);

if strcmp(tmtag,'end point 1')
    tf=findobj(h1,'tag','end point 2');
else
    tf=findobj(h1,'tag','end point 1');
end
fp=cell2mat(get(tf,{'xdata' 'ydata'}));%fix xy
mp=cell2mat(get(tm,{'xdata' 'ydata'}));%moving xy


%____________________mm-distance____________________________
hdim=findobj(gcf,'tag','rd_changedim');
transpose=get(findobj(gcf,'tag','rd_transpose'),'value');
or=get(hdim,{'string' 'value'});
dimused=str2num(or{1}{or{2}});
u=get(gcf,'userdata');
dim=u.ha.dim;
mat=u.ha.mat;

dim(dimused)=[];
voxsi=diag(mat(1:3,1:3))';
voxsi(dimused)=[];

if transpose==1
    voxsi=fliplr(voxsi);
    dim  =fliplr(dim);
end

dfdo=abs(fp(2)-mp(2));
dfri=abs(fp(1)-mp(1));

mmri=dfri*voxsi(2);
mmdo=dfdo*voxsi(1);
mm=sqrt(mmri.^2+mmdo.^2);

% dum1=get(findobj(gcf,'type','image'),'xdata');
% dum2=get(findobj(gcf,'type','image'),'ydata');
% imgdim=[dum1(2) dum2(2)];

set(hl,'string',{['s: '  sprintf('%2.3f',mm) 'mm']
    ['s: '  sprintf('%2.3f',dis) 'pix']
    ['{\theta}: '  sprintf('%2.3f',ang) 'ｰ']},'fontsize',8);


%________________________________________________
set(tm,'MarkerSize',20);
set(tf,'MarkerSize',20);

if 0
    df=fp-mp;
    set(hl,'position',[fp(1)+sign(df(1))*14 fp(2)+sign(df(2))*14 0]);
    if mp(2)<=fp(2) %virtually mp is above fp
        disp(rand(1))
        set(hl,'position',[fp(1)+sign(df(1))*14 fp(2)+sign(df(2))*14*2 0]);
        if ang==0
            set(hl,'position',[fp(1)+sign(df(1))*14*2 fp(2)+14*2 0]);
        end
    else
        se
        t(hl,'position',[fp(1)+sign(df(1))*14 fp(2)+sign(df(2))*14*2 0]);
    end
end
set(hl,'backgroundcolor','k','color',[1.0000 0.8431  0],'fontsize',7,'fontweight','bold');
xl=xlim;
yl=ylim;
% ce=round((fp+mp)/2);
% if ce(1)<mean(xl)
%     set(hl,'position',[xl(2)-xl(2)*.25  yl(2)-yl(2)*.05]);
% else
    set(hl,'position',[xl(1)+xl(2)*.05  yl(2)-yl(2)*.05]);
% end
lpos=get(hl,'Extent');

b(1)=fp(1)>lpos(1) &&  fp(1)<lpos(2) && fp(2)>lpos(2)-lpos(4) &&  fp(2)<lpos(2);
b(2)=mp(1)>lpos(1) &&  mp(1)<lpos(2) && mp(2)>lpos(2)-lpos(4) &&  mp(2)<lpos(2);
b(3)=fp(2)>lpos(2)-lpos(4) &&  fp(2)<lpos(2) && mp(2)>lpos(2)-lpos(4) &&  mp(2)<lpos(2);
% disp(b);
if b(3)==1
    set(hl,'position',[xl(1)+xl(2)*.05  yl(1)+yl(2)*.075]);
else
    if any(b)==1
        set(hl,'position',[xl(2)-xl(2)*.25  yl(2)-yl(2)*.05]);
    end
end

% disp(get(hl,'position'));
% set(hl,'fontweight','bold');


function pb_deldistfun(e,e2,api1)
delete(api1);
delete(findobj(gcf,'tag','pb_deldistfun'));
hb=findobj(gcf,'tag','pb_measureDistance');
set(hb,'value',0);
hgfeval(get( hb ,'callback'));




function pb_measureDistance(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
val=get(findobj(gcf,'tag','pb_measureDistance'),'value');

if val==0 %off
    try; delete(u.meas.api); end
    try; delete(u.meas.h1); end
    %     try; delete(get(findobj(hf1,'tag','end point 1'),'parent')); end
    try;  delete(findobj(hf1,'tag','pb_deldistfun'));end
    
%     hb=findobj(gcf,'tag','undo');
%     hgfeval(get( hb ,'callback'));
    
else
    %set(hf1,'Pointer','arrow');
%     hb=findobj(gcf,'tag','undo');
%     hgfeval(get( hb ,'callback'));

set(gcf,'WindowButtonDownFcn',[]);
set(gca,'ButtonDownFcn',[]);
set(findobj(gcf,'type','image'),'ButtonDownFcn',[]);
    create_distanceMeas();
    
end

function pb_measureDistance_off()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
set(findobj(gcf,'tag','pb_measureDistance'),'value',0);

try; delete(u.meas.api); end
try; delete(u.meas.h1); end
try; delete(get(findobj(hf1,'tag','end point 1'),'parent'));end
try; delete(findobj(hf1,'tag','pb_deldistfun')); end
    
%     hb=findobj(gcf,'tag','undo');
%     hgfeval(get( hb ,'callback'));

function r1=adjustIntensity(r1);
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','cb_adjustIntensity');
if get(hb,'value')==1
    uv=get(hb,'userdata');
    if isfield(uv,'lims') && ~isempty(uv.lims)
          %r1=imadjust(mat2gray(r1),[0.3 0.7],[1 0]);
          if uv.lims(2)>uv.lims(1)
              r1=imadjust(mat2gray(r1),sort(uv.lims));
          else
              r1=imadjust(mat2gray(r1),sort(uv.lims),[1 0]);
          end
    else
      r1=imadjust(mat2gray(r1));
    end

end


function cb_adjustIntensity(e,e2)
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','cb_adjustIntensity');
% set(hb,'value');
setslice();

function cb_adjustIntensity_value(e,e2)
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','cb_adjustIntensity_value');
hj=get(hb,'userdata');
lims=str2num(char(hj.getSelectedItem));
if length(lims)==1
    hj.setSelectedIndex(0);
    cb_adjustIntensity_value()
    return;
end
hr=findobj(hf1,'tag','cb_adjustIntensity');
uv.lims=lims;
set(hr,'userdata',uv);
setslice();
