import { LightningElement } from 'lwc';
import generate from '@salesforce/apex/SessionPackController.generate';

/**
 * SessionPackHub
 * - Collects inputs for the session pack (description, timestamps, language, mainTopic)
 * - Calls Apex to execute the Einstein Prompt Template
 * - Renders structured JSON results in accordion sections
 * - Provides "copy" helpers for quick reuse
 */
export default class SessionPackHub extends LightningElement {
  // ---- inputs (two-way bound) ----
  newVideoDescription = '';
  newVideoTimestamps  = '';
  language            = 'English';
  mainTopic           = '';

  // ---- UI state ----
  isWorking = false;
  error;
  resultJson;

  // ---- parsed result ----
  pack = null;

  get languageOptions() {
    return [
      { label: 'English (EN)', value: 'English' },
      { label: 'Arabic (AR)',  value: 'Arabic'  }
    ];
  }

  /////////////// Input handlers /////////////
  handleDescChange(e) { this.newVideoDescription = e.target.value || ''; }
  handleTsChange(e)   { this.newVideoTimestamps  = e.target.value || ''; }
  handleLangChange(e) { this.language            = e.detail.value || 'English'; }
  handleTopicChange(e){ this.mainTopic           = (e.target.value || '').trim(); }
  ////////////////////////////////////////////

  // Generate session pack by calling Apex (Prompt Template under the hood)
  async handleGenerate(){
    this.isWorking = true;
    this.error     = null;
    this.resultJson= null;
    this.pack      = null;

    try {
      // Light normalization before sending
      const payload = {
        newVideoDescription: (this.newVideoDescription || '').trim(),
        newVideoTimestamps : (this.newVideoTimestamps  || '').trim(),
        language           : this.language || 'English',
        mainTopic          : this.mainTopic || ''
      };

      const promptResponse = await generate(payload);

      if (promptResponse?.error) throw new Error(promptResponse.error);
      if (!promptResponse?.json) throw new Error('No JSON returned from Prompt.');

      this.resultJson = promptResponse.json;

      let promptResponseParsed;
      try {
        promptResponseParsed = JSON.parse(this.resultJson);
      } catch (e) {
        throw new Error('Invalid JSON returned from Prompt: ' + e.message);
      }

      // Ensure arrays are arrays
      const playlists     = Array.isArray(promptResponseParsed.playlists)
        ? promptResponseParsed.playlists : [];
      const relatedVideos = Array.isArray(promptResponseParsed.relatedVideos)
        ? promptResponseParsed.relatedVideos : [];

      // Spread + sanitized overrides
      this.pack = { ...promptResponseParsed, playlists, relatedVideos };

    } catch (e) {
      this.error = e?.message || 'Unexpected error.';
    } finally {
      this.isWorking = false;
    }
  }

  /////////////////////// Copy helpers ///////////////////////
  // Copies any string to the clipboard. Falls back to an empty string on null/undefined.
  async copyToClipboard(value) {
    const text = value ?? '';
    try {
      await navigator.clipboard.writeText(text);
      // Optionally show a toast here
    } catch (err) {
      // Optionally: console.warn('Copy failed:', err);
    }
  }

  copyJson()           { this.copyToClipboard(this.resultJson); }
  copyTitle()          { this.copyToClipboard(this.pack?.youtubeTitle); }
  copyDescription()    { this.copyToClipboard(this.pack?.youtubeDescription); }
  copyHashtagsLine()   { this.copyToClipboard(this.pack?.hashtagsLine); }
  copyHashtagsCSV()    { this.copyToClipboard(this.pack?.hashtagsCSV); }
  copyLinkedIn()       { this.copyToClipboard(this.pack?.linkedinPost); }
  copyTwitter()        { this.copyToClipboard(this.pack?.twitterPost); }

  // Copy related as "Title : URL" lines for quick paste into LinkedIn/YouTube
  copyRelatedAsPairs() {
    const lines = (this.pack?.relatedVideos || [])
      .map(v => `${v.title} : ${v.url}`)
      .join('\n');
    this.copyToClipboard(lines);
  }
  ////////////////////////////////////////////////////////////
}