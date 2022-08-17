using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using PicatBlazorMonaco;
using System;
using System.Net.Http;
using System.Threading.Tasks;
using Syncfusion.Blazor;
using KristofferStrube.Blazor.FileSystemAccess;

namespace ProjectionalBlazorMonaco
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            Syncfusion.Licensing.SyncfusionLicenseProvider.RegisterLicense("Njk2NjUyQDMyMzAyZTMyMmUzMFR5djRXRzQ1ZzNBbVZFL0NNSkhNODZNUTZCRlJQc096cHJQOWc2TjZTT3c9");
            var builder = WebAssemblyHostBuilder.CreateDefault(args);
            builder.RootComponents.Add<App>("#app");

            builder.Services.AddScoped(sp => new HttpClient {
                BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) 
            });

            builder.Services.AddSyncfusionBlazor();
            builder.Services.AddFileSystemAccessService();
            builder.Services.AddScoped<myText>();

            await builder.Build().RunAsync();
        }
    }
}
